#!/bin/bash

r_flag=0
a_flag=0

# list available options
usage() {
    echo "-------------------------------------------------------------------"
    echo "spacerate.sh -r | -a <file1> <file2>"
    echo
    echo "OPÇÕES DISPONÍVEIS:"
    echo
    echo "  -r  : Ordena a saída em ordem decrescente de tamanho"
    echo "  -a  : Ordena a saída em ordem alfabética"
    echo "  -h  : Mostra a ajuda"
   echo "-------------------------------------------------------------------" 
}
# Process the flags
while getopts 'rah' opt; do
    case $opt in
        r) r_flag=1 ;;
        a) a_flag=1 ;;
        h) usage; exit 0 ;;
        \?) echo "Invalid option: -$OPTARG" >&2
            exit 1 ;;
    esac
done

# Shift off the options and flags
shift $((OPTIND - 1))

# Check if two input files are provided
if [ $# -ne 2 ]; then
    echo "Two input files are required."
    exit 1
fi

# Assign input file names to variables
file1="$1"  # Most recent file
file2="$2"  # Older file

# Check if the input files exist
if [ ! -f "$file1" ] || [ ! -f "$file2" ]; then
    echo "Input files do not exist."
    exit 1
fi

# Declare associative arrays
declare -A file1_dirs 
declare -A file2_dirs

# Read file1 into file1_dirs
while IFS=' ' read -r size name || [ -n "$size" ]; do
    if [[ -n $name ]] && [[ -n $size ]]; then
        file1_dirs["$name"]=$size
    fi
done < <(tail -n +2 "$file1") # Skip first line

# Read file2 into file2_dirs
while IFS=' ' read -r size name || [ -n "$size" ]; do
    if [[ -n $name ]] && [[ -n $size ]]; then
        file2_dirs["$name"]=$size
    fi
done < <(tail -n +2 "$file2") # Skip first line

output=""
# Compare directories in file1 to those in file2
for name in "${!file1_dirs[@]}"; do
    size1=${file1_dirs["$name"]}
    size2=${file2_dirs["$name"]}
    if [[ -z $size2 ]]; then
        # Directory is new in file1
        output+="${size1} $name NEW\n"
    elif [[ $size1 -ne $size2 ]]; then
        diff_size=$((size1 - size2))
        output+="${diff_size} $name\n"
    else
        # Same size in both files
        output+="0 $name\n"
    fi
done

# Check for directories that are in file2 but not in file1 (removed directories)
for name in "${!file2_dirs[@]}"; do
    if [[ -z ${file1_dirs["$name"]} ]]; then
        size2=${file2_dirs["$name"]}
        neg_size=$((0 - size2))
        output+="${neg_size} $name REMOVED\n"
    fi
done

# Output results based on flags
if [ "$r_flag" -eq 1 ]; then
    echo -e "$output" | awk 'NF' | sort -k1,1nr | tac
elif [ "$a_flag" -eq 1 ]; then
    echo -e "$output" | awk 'NF' | sort -k2,2
else
    echo -e "$output" | awk 'NF' | sort -k1,1nr
fi
#!/bin/bash

r_flag=0
a_flag=0
l_flag=0

table_lines=0
# list available options
usage() {
    echo "-------------------------------------------------------------------"
    echo "spacerate.sh -r | -a | -l <file1> <file2>"
    echo
    echo "OPÇÕES DISPONÍVEIS:"
    echo
    echo "  -r  : Ordena a saída em ordem decrescente de tamanho"
    echo "  -a  : Ordena a saída em ordem alfabética"
    echo "  -l  : Limita o número de linhas de saída"
    echo "  -h  : Mostra a ajuda"
   echo "-------------------------------------------------------------------" 
}
# process the flags
while getopts 'rahl:' opt; do
    case $opt in
        r) r_flag=1 ;;
        a) a_flag=1 ;;
        l) l_flag=1; table_lines=$OPTARG;;
        h) usage; exit 0 ;;
        \?) echo "Invalid option: -$OPTARG" >&2 # stop program
            exit 1 ;;
    esac
done

# shift the options so that the input files are the first arguments
shift $((OPTIND - 1))

# check if two input files are provided
if [ $# -ne 2 ]; then
    echo "Two input files are required."
    exit 1
fi

file1="$1"  # Most recent file
file2="$2"  # Older file

# check if the files exist
if [ ! -f "$file1" ] || [ ! -f "$file2" ]; then 
    echo "Input files do not exist."
    exit 1
fi

declare -A file1_dirs 
declare -A file2_dirs

# read file1 into file1_dirs
while IFS=' ' read -r size name rest; do
    if [[ -n $name ]] && [[ -n $size ]]; then
        full_name="${name}${rest:+ $rest}"  # name + rest
        file1_dirs["$full_name"]=$size
    fi
done < <(tail -n +2 "$file1") # skip first line

# read file2 into file2_dirs
while IFS=' ' read -r size name rest; do
    if [[ -n $name ]] && [[ -n $size ]]; then
        full_name="${name}${rest:+ $rest}"  # name + rest
        file2_dirs["$full_name"]=$size
    fi
done < <(tail -n +2 "$file2") # skip first line


output=""
# compare directories in file1 to those in file2
for name in "${!file1_dirs[@]}"; do
    size1=${file1_dirs["$name"]}
    size2=${file2_dirs["$name"]}
    if [[ -z $size2 ]]; then
        # directory in file1 and not in file2 (new directory)
        output+="${size1} $name NEW\n"
    elif [[ $size1 -ne $size2 ]]; then
        # different size in both files
        diff_size=$((size1 - size2))
        output+="${diff_size} $name\n"
    else
        # same size in both files
        output+="0 $name\n"
    fi
done

# check for directories that are in file2 but not in file1 (removed directories)
for name in "${!file2_dirs[@]}"; do
    if [[ -z ${file1_dirs["$name"]} ]]; then
        size2=${file2_dirs["$name"]}
        neg_size=$((0 - size2))
        output+="${neg_size} $name REMOVED\n"
    fi
done

sorted_output=$(echo -e "$output" | awk 'NF')


if [ "$r_flag" -eq 1 ] && [ "$a_flag" -eq 1 ]; then

    sorted_output=$(echo "$sorted_output" | sort -k2,2 | tac)
elif [ "$r_flag" -eq 1 ]; then
    sorted_output=$(echo "$sorted_output" | sort -k1,1nr | tac)
elif [ "$a_flag" -eq 1 ]; then
    sorted_output=$(echo "$sorted_output" | sort -k2,2)
fi

if [ "$l_flag" -eq 1 ]; then
    sorted_output=$(echo "$sorted_output" | head -n $table_lines)
fi

echo "SIZE NAME"
echo "$sorted_output"

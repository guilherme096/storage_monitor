#!/bin/bash

dir="${!#}"
current_date=$(date +%Y%m%d)

n_flag=0
d_flag=0
s_flag=0
r_flag=0
a_flag=0
l_flag=0

flags=""

items=""
regex=""
flag_date=""
min_size=""
table_lines=0

usage(){
    echo "-------------------------------------------------------------------------------------"
    echo "./spacecheck.sh [OPÇÕES] <diretório1> <diretório2> ... <diretórioN>"
    echo
    echo "OPÇÕES DISPONÍVEIS:"
    echo
    echo "  -n <regex>      : Lista apenas os arquivos que casam com a expressão regular"
    echo "  -d <data>       : Lista apenas os arquivos modificados após a data especificada"
    echo "  -s <tamanho>    : Lista apenas os arquivos maiores que o tamanho especificado"
    echo "  -r              : Ordena a saída em ordem decrescente de tamanho"
    echo "  -a              : Ordena a saída em ordem alfabética"
    echo "  -l <linhas>     : Limita a saída a um número de linhas especificado"
    echo "  -h              : Mostra a ajuda"
    echo "-------------------------------------------------------------------------------------"
}

# get flags
while getopts 'n:d:s:ral:h' opt; do
    case $opt in
        n) n_flag=1; regex="$OPTARG"; flags+=" -n";;
        d) d_flag=1; flag_date="$OPTARG"; flags+=" -d";;
        s) s_flag=1; min_size="$OPTARG"; flags+=" -s";;
        r) r_flag=1; flags+=" -r";;
        a) a_flag=1; flags+=" -a";;
        l) l_flag=1; table_lines=$OPTARG; flags+=" -l";;
        h) usage; exit 0;;
        \?) echo "Invalid option: -$OPTARG" >&2;; # TODO: stop program
    esac
done

if [ "$s_flag" -eq 1 ] && { [ -z "$min_size" ] || [ "$min_size" -lt 0 ]; }; then
    echo "Invalid size: $min_size"
    exit 1
fi
if [ "$l_flag" -eq 1 ] && { [ -z "$table_lines" ] || [ "$table_lines" -lt 0 ]; }; then
    echo "Invalid line size: $table_lines"
    exit 1
fi



get_size(){
    local dir="$1"
    local find_command="find \"$dir\" -type f"
    
    # check if the directory is accessible
    if [ ! -r "$dir" ] || [ ! -x "$dir" ]; then
        echo "NA"
        return
    fi

    if [ -n "$regex" ]; then
        find_command+=" -regex \"$regex\""
    fi
    if [ -n "$flag_date" ]; then
        find_command+=" -newermt \"$flag_date\""
    fi

    local total_size=0
    local file_size
    local error_occurred=0

    # execute find command and handle each file
    while IFS= read -r file; do
        # check if the file is readable
        if [ ! -r "$file" ]; then
            error_occurred=1
            break
        fi

        file_size=$(du -b "$file" 2>/dev/null | awk '{print $1}')
        if [ -z "$file_size" ]; then
            continue
        fi

        if [ -z "$min_size" ] || [ "$file_size" -ge "$min_size" ]; then
            total_size=$((total_size + file_size))
        fi
    done < <(eval "$find_command" 2>&1)

    if ([ "$error_occurred" -eq 1 ] || [[ $(eval "$find_command" 2>&1) == *"Permission denied"* ]]); then
        echo "NA"
    else
        echo "$total_size"
    fi
}


get_dirs(){
    local dir="$1"
    local dir_items

    #get dirs, and remove './' prefix
    dir_items=$(find "$dir" -type d 2>/dev/null | sed 's|^./||')
    if [ -n "$dir_items" ]; then
        [ -n "$items" ] && items+=$'\n'
        items+="$dir_items"
    fi
}

# lists items 
list_items(){
    interface
    local count=0

    if [ "$a_flag" -eq 1 ]; then
        items=$(echo -e "$items" | sort)
    fi
    if [ "$r_flag" -eq 1 ]; then
        items=$(echo -e "$items" | sort -r)
    fi

    # process each directory
    echo -e "$items" | while IFS= read -r dir; do
        ((count++))
        if [ "$l_flag" -eq 1 ] && [ $count -gt $table_lines ]; then
            break
        fi

        size=$(get_size "$dir")

        echo -e "$size\t$dir"
    done
}

# remove flags from arguments to parse dirs
shift $((OPTIND -1))

validate_date(){
    if [ $d_flag -eq 0 ]; then
        return 0
    fi
    local date="$1"
    local months=("Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")
    local days_in_month=(31 28 31 30 31 30 31 31 30 31 30 31)

    if [ -n "$date" ]; then
        local date_array=($date)
        month=${date_array[0]}
        day=${date_array[1]}
        time=${date_array[2]}

        if [ ${#date_array[@]} -lt 2 ] || [ ${#date_array[@]} -gt 3 ]; then
            echo "Invalid date format: $date"
            exit 1
        fi

        if [[ " ${months[*]} " != *" $month "* ]]; then
            echo "Invalid month: $month"
            exit 1
        fi

        if (($day < 1 || $day > ${days_in_month[${#months[@]}-1]})); then
            echo "Invalid day for month $month: $day"
            exit 1
        fi

        if [ -n "$time" ]; then

            if ! [[ "$time" =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]$ ]]; then
                echo "Invalid time format: $time"
                exit 1
            fi
        fi
    fi
}


interface(){
    current_date=$(date +%Y%m%d)
    base="SIZE     NAME     $current_date "
    if [ "$r_flag" -eq 1 ]; then
        base+="-r "
    fi
    if [ "$a_flag" -eq 1 ]; then
        base+="-a "
    fi
    if [ "$s_flag" -eq 1 ]; then
        base+="-s $min_size "
    fi
    if [ "$d_flag" -eq 1 ]; then
        base+="-d \"$flag_date\" "
    fi
    if [ "$n_flag" -eq 1 ]; then
        base+="-n \"$regex\" "
    fi
    if [ "$l_flag" -eq 1 ]; then
         base+="-l $table_lines "
    fi
    echo "$base $dirs"
}


if ! validate_date "$flag_date" ; then
    exit 1
fi

dirs="$@"
for dir in "$@"; do
    get_dirs "$dir"
done


output_file="spacecheck_$current_date"

list_items | tee "$output_file"

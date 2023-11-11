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
date=""
min_size=""
table_lines=0

# get flags
while getopts 'n:d:s:ral:' opt; do
    case $opt in
        n) n_flag=1; regex="$OPTARG"; flags+=" -n";;
        d) d_flag=1; date="$OPTARG"; flags+=" -d";;
        s) s_flag=1; min_size="$OPTARG"; flags+=" -s";;
        r) r_flag=1; flags+=" -r";;
        a) a_flag=1; flags+=" -a";;
        l) l_flag=1; table_lines=$OPTARG; flags+=" -l";;
        \?) echo "Invalid option: -$OPTARG" >&2;; # TODO: stop program
    esac
done

validate_date(){
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

        # Check if the time is in the format HH:MM
        if [ -n "$time" ]; then
            # Check if the time is in the format HH:MM
            if ! [[ "$time" =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]$ ]]; then
                echo "Invalid time format: $time"
                exit 1
            fi
        fi
    fi
}

# gets the size of one item
get_size(){
  item=$1
    find_command="find \"$item\" -type f"
    if [ -n "$regex" ]; then
      find_command+=" -regex \"$regex\""
    fi
    if [ -n "$date" ] && validate_date "$date"; then
      find_command+=" -newermt \"$date\""
    fi
    if [ -n "$min_size" ]; then
      find_command+=" -size +${min_size}c"
    fi
    files=$(eval "$find_command") 

    size="NA"
    if [ -n "$files" ]; then
        size=$(echo "$files" | xargs du -b | awk '{sum+=$1} END {print sum}')
    fi
}

# interface
interface(){
    current_date=$(date +%Y%m%d)
    echo "SIZE     NAME     $current_date   $flags $regex $date $min_size $table_lines $dir"
}

# checks the existance of the dir and whether it can be accessed
check_dir_and_file(){
    local target="$1"
    if [ -e "$target" ]; then
        if [ -d "$target" ]; then
            return 0
        fi
    else
        return 1
    fi
}

# checks if the last arguments is a directory
if [ $# -eq 0 ]; then
    echo "No arguments provided."
    exit 1
else
    check_dir_and_file "$dir"
    if [ $? -ne 0 ]; then
        echo "The directory does not exist or is not accessible."
        exit 1
    fi
fi

get_dirs(){
    if [ "$d_flag" -eq 1 ]; then
        items=$(find "$dir" -type d -newermt "$date")
    else
        items=$(find "$dir" -type d)
    fi
}

# lists items in the items variable with their size
list_items(){
    #invert $items if -r flag is set
    if [ "$r_flag" -eq 1 ]; then
        items=$(echo "$items" | tac)
    fi
    if [ "$a_flag" -eq 1 ]; then
        items=$(echo "$items" | sort)
    fi

    local count=0
    for item in $items; do
        ((count++))
        lines=$((table_lines+1))
        if [ "$l_flag" -eq 1 ] && [ $count -ge $lines ]; then
            break
        fi
        size=''
        get_size $item
        echo -e "$size\t$item" 
    done
}


main(){
    interface 
    get_dirs
    list_items
}
main >> "spacecheck_$current_date"

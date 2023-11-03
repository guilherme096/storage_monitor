#!/bin/bash

dir="./samples/"

n_flag=0
d_flag=0
s_flag=0
r_flag=0
l_flag=0

items=""
regex=""
date=""

# get flags
while getopts 'n:d:slr' opt; do
    case $opt in
        n) n_flag=1; regex="$OPTARG";;
        d) d_flag=1; date="$OPTARG";;
        s) s_flag=1;;
        l) l_flag=1;;
        r) r_flag=1;;
        \?) echo "Invalid option: -$OPTARG" >&2;; # TODO: stop program
    esac
done

# gets the size of one item
get_size(){
  item=$1
    find_command="find \"$item\" -type f"
    if [ -n "$regex" ]; then
        find_command+=" -regex \"$regex\""
    fi
    if [ -n "$date" ]; then
      find_command+=" -newermt \"$date\""
    fi
    files=$(eval "$find_command")

    size="NA"
    if [ -n "$files" ]; then
        size=$(echo "$files" | xargs du -b | awk '{sum+=$1} END {print sum}')
    fi
}

# interface
interface(){
    echo "SIZE     NAME    $flags $regex $date $dir"
}

get_dirs(){
    if [ "$d_flag" -eq 1 ]; then
        items=$(find "$dir" -type d -newermt "$date")
    else
        items=$(find "$dir" -type d)
    fi

}

# lists items in the items variable with their size
list_items(){
    for item in $items; do
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
main

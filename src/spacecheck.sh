#!/bin/bash

dir="./samples/"
items=""


n_flag=0
d_flag=0
s_flag=0
r_flag=0
l_flag=0

regex=""

# get flags
while getopts 'n:dslr' opt; do
    case $opt in
        n) n_flag=1; regex="$OPTARG";;
        d) d_flag=1;;
        s) s_flag=1;;
        l) l_flag=1;;
        r) r_flag=1;;
        \?) echo "Invalid option: -$OPTARG" >&2;; # TODO: stop program
    esac
done

# gets the size of one item
get_size(){
    item=$1
    size=$(du -s -b $item | awk '{print $1}')
}

# interface
interface(){
    echo "SIZE     NAME    $flags $regex $dir"
}

get_items(){
    if [ $n_flag -eq 1 ]; then
        items=$(find "$dir" -type f -regex "$regex")
    else
        items=$(find "$dir" -type f)
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
    get_items
    list_items
}
main

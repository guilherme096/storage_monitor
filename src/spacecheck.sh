#!/bin/bash

# variables
dir="./samples/"

# find only dirs and subdirs
items=$(find $dir -type d)


n_flag=0
d_flag=0
s_flag=0
r_flag=0
l_flag=0

regex=""

# get flags
while getopts 'ndslr' opt; do
    case $opt in
        n) n_flag=1;;
        d) d_flag=1;;
        s) s_flag=1;;
        l) l_flag=1;;
        r) r_flag=1; regex=$OPTARG;;
        \?) echo "Invalid option: -$OPTARG" >&2;;
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
    list_items
}
main

#!/bin/bash

# variables
dir=$(pwd)

# find only dirs and subdirs
items=$(find $dir -type d)



# gets the size of one item
get_size(){
    item=$1
    size=$(du -s -b $item | awk '{print $1}')
}

# lists items in the items variable with their size
list_items(){
    for item in $items; do
        size=''
        get_size $item
        echo -e "$size\t$item" 
    done
}

list_items

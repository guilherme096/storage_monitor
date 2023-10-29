#!/bin/bash

dir=$(pwd)

items=$(find $dir)

list_items(){
    for item in $items
    do
        echo $item 
    done
}

list_items

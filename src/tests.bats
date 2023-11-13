#!/usr/bin/env bats

executable=./spacecheck.sh 
dir=./samples

@test "Samples" {
    run $executable $dir
    [ "$status" -eq 0 ]
}
@test "Regex" {
    run $executable $dir
    [ "$status" -eq 0 ]
}
@test "Date" {
    run $executable $dir
    [ "$status" -eq 0 ]
}
@test "Size" {
    run $executable $dir
    [ "$status" -eq 0 ]
}

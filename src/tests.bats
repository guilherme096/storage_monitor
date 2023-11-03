#!/usr/bin/env bats

@test "Simple" {
    run ./spacecheck.sh
    [ "$status" -eq 0 ]
}

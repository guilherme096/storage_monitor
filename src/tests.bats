#!/usr/bin/env bats

executable=./spacecheck.sh

@test "Executes" {
    run $executable
    [ "$status" -eq 0 ]
}

@test "Check if the script prints the correct directory sizes" {
  run $executable
  [ "$status" -eq 0 ]

  output_without_spaces=$(echo "$output" | tr -d '[:space:]')
  expected_output_without_spaces="SIZENAME./samples/605229./samples/397628./samples/dir1198814./samples/dir1/sub1"
  if [ "$output_without_spaces" != "$expected_output_without_spaces" ]; then
    echo "$output"
    echo "$expected_output_without_spaces"
  fi
  [ "$output_without_spaces" = "$expected_output_without_spaces" ]
}

@test "Regex: Only PDFs" {
  run $executable -n ".*pdf"
  [ "$status" -eq 0 ]

  output_without_spaces=$(echo "$output" | tr -d '[:space:]')
  expected_output_without_spaces="SIZENAME.*pdf./samples/596442./samples/397628./samples/dir1198814./samples/dir1/sub1"
  if [ "$output_without_spaces" != "$expected_output_without_spaces" ]; then
    echo "$output"
    echo "$expected_output_without_spaces"
  fi

  [ "$output_without_spaces" = "$expected_output_without_spaces" ]
}

@test "Date: Oct 30 10:00" {
  run $executable -d "Oct 30 10:00"
  [ "$status" -eq 0 ]

  output_without_spaces=$(echo "$output" | tr -d '[:space:]')
  expected_output_without_spaces="SIZENAMEOct3010:00./samples/8787./samples/"
  if [ "$output_without_spaces" != "$expected_output_without_spaces" ]; then
    echo "$output"
    echo "$expected_output_without_spaces"
  fi

  [ "$output_without_spaces" = "$expected_output_without_spaces" ]
}
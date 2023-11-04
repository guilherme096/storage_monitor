#!/usr/bin/env bats

executable=./spacecheck.sh 
dir=./samples

@test "Executes" {
    run $executable $dir
    [ "$status" -eq 0 ]
}

@test "Check if the script prints the correct directory sizes" {
  run $executable $dir
  [ "$status" -eq 0 ]
  [ "$status" -eq 0 ]

  output_without_spaces=$(echo "$output" | tr -d '[:space:]')
  expected_output_without_spaces="SIZENAME./samples605229./samples397628./samples/dir1198814./samples/dir1/sub1"
  if [ "$output_without_spaces" != "$expected_output_without_spaces" ]; then
    echo "$output"
    echo "$expected_output_without_spaces"
  fi
  [ "$output_without_spaces" = "$expected_output_without_spaces" ]
}

@test "Regex: Only PDFs" {
  run $executable -n ".*pdf" $dir
  [ "$status" -eq 0 ]
  [ "$status" -eq 0 ]

  output_without_spaces=$(echo "$output" | tr -d '[:space:]')
  expected_output_without_spaces="SIZENAME.*pdf./samples596442./samples397628./samples/dir1198814./samples/dir1/sub1"
  if [ "$output_without_spaces" != "$expected_output_without_spaces" ]; then
    echo "$output"
    echo "$expected_output_without_spaces"
  fi

  [ "$output_without_spaces" = "$expected_output_without_spaces" ]
}

@test "Date: Oct 30 10:00" {
  run $executable -d "Oct 30 10:00" $dir
  [ "$status" -eq 0 ]

  output_without_spaces=$(echo "$output" | tr -d '[:space:]')
  expected_output_without_spaces="SIZENAMEOct3010:00./samples8787./samples"
  if [ "$output_without_spaces" != "$expected_output_without_spaces" ]; then
    echo "$output"
    echo "$expected_output_without_spaces"
  fi

  [ "$output_without_spaces" = "$expected_output_without_spaces" ]
}


@test "Date and Regex: Oct 30 10:00 .*text" {
  run $executable -d "Sep 10 10:00" -n ".*txt" $dir

  [ "$status" -eq 0 ]

  output_without_spaces=$(echo "$output" | tr -d '[:space:]')
expected_output_without_spaces="SIZENAME.*txtSep1010:00./samples8787./samplesNA./samples/dir1NA./samples/dir1/sub1"

  if [ "$output_without_spaces" != "$expected_output_without_spaces" ]; then
    echo "$output"
    echo "$expected_output_without_spaces"
  fi

  [ "$output_without_spaces" = "$expected_output_without_spaces" ]
}

@test "Min Size 9000" {
  run $executable -s "9000" $dir

  [ "$status" -eq 0 ]

  output_without_spaces=$(echo "$output" | tr -d '[:space:]')
  expected_output_without_spaces="SIZENAME./samples596442./samples397628./samples/dir1198814./samples/dir1/sub1"


  if [ "$output_without_spaces" != "$expected_output_without_spaces" ]; then
    echo "$output"
    echo "$expected_output_without_spaces"
  fi

  [ "$output_without_spaces" = "$expected_output_without_spaces" ]
}


@test "Reverse Order" {
  run $executable -r $dir

  [ "$status" -eq 0 ]

  output_without_spaces=$(echo "$output" | tr -d '[:space:]')
  expected_output_without_spaces="SIZENAME./samples198814./samples/dir1/sub1397628./samples/dir1605229./samples"



  if [ "$output_without_spaces" != "$expected_output_without_spaces" ]; then
    echo "$output"
    echo "$expected_output_without_spaces"
  fi

  [ "$output_without_spaces" = "$expected_output_without_spaces" ]
}


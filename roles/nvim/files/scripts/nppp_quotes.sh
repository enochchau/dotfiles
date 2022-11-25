#!/usr/bin/env bash

file_name='./quotes.json'
temp_file='/tmp/nppp_quotes_src.cpp'

curl https://raw.githubusercontent.com/notepad-plus-plus/notepad-plus-plus/master/PowerEditor/src/Notepad_plus.cpp > \
  $temp_file

grep 'TEXT.*QuoteParams.*TEXT' < $temp_file \
  | sed 's/.*TEXT("\(.*\)").*TEXT("\(.*\)").*/{"quote": "\2", "author": "\1"}/' \
  | sed 's/[^[:print:]]//g' \
  | jq -s > $file_name

rm $temp_file

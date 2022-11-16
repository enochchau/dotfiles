#!/usr/bin/env bash

file_name='lua/enoch/quotes.json'

curl https://raw.githubusercontent.com/notepad-plus-plus/notepad-plus-plus/master/PowerEditor/src/Notepad_plus.cpp > Notepad_plus.cpp
# dos2unix Notepad_plus.cpp
grep 'TEXT.*QuoteParams.*TEXT' < Notepad_plus.cpp \
  | sed 's/.*TEXT("\(.*\)").*TEXT("\(.*\)").*/{"quote": "\2", "author": "\1"}/' \
  | tr -dc '[:print:]\n' \
  | jq -s > $file_name
rm Notepad_plus.cpp

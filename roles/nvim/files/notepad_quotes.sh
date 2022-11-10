#!/usr/bin/env bash

curl https://raw.githubusercontent.com/notepad-plus-plus/notepad-plus-plus/master/PowerEditor/src/Notepad_plus.cpp > Notepad_plus.cpp
dos2unix Notepad_plus.cpp
echo "return {" > ./lua/enoch/quotes.lua
cat Notepad_plus.cpp | grep 'TEXT.*QuoteParams.*TEXT' | sed 's/.*TEXT("\(.*\)").*TEXT("\(.*\)").*/{"\2", " - \1"},/' >> ./lua/enoch/quotes.lua
echo "}" >> ./lua/enoch/quotes.lua
rm Notepad_plus.cpp

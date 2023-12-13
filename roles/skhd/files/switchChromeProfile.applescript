#!/usr/bin/env osascript

set appName to "Google Chrome"
set isRunning to application appName is running

tell application appName to activate
if isRunning then
  do shell script "skhd -k 'cmd + shift - m'"
  do shell script "skhd -k 'return'"
end if

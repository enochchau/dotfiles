#!/usr/bin/env osascript

set appName to "Alacritty"

if application appName is running
  do shell script "alacritty msg create-window"
  tell application appName to activate
else
  tell application appName to activate
end if

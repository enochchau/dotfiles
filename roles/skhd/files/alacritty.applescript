#!/usr/bin/env osascript

set appName to "Alacritty"

if not application appName is running then
  tell application id (id of application appName)
    tell application appName to activate
  end tell
else
  do shell script "alacritty msg create-window"
  tell application "System Events"
    tell application process appName
      set frontmost to true
    end tell
  end tell
end if

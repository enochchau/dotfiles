#!/usr/bin/env osascript

set appName to "Alacritty"

if not application appName is running then
  tell application id (id of application appName)
    tell application appName to activate
  end tell

  return 1
else
  return 0
end if

#!/usr/bin/env osascript

set appName to "Ghostty"

if application appName is running
  tell application "System Events"
    tell process appName
        click menu item "New Window" of menu "File" of menu bar 1
    end tell
end tell
else
  tell application appName to activate
end if

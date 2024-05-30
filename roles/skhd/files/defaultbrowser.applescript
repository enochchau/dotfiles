#!/usr/bin/env osascript

on run argv
  if (length of argv) < 1 then
    return "No browser specified"
  end if

  set browser to item 1 of argv
  do shell script "defaultbrowser " & browser

  try
    tell application "System Events"
      tell application process "CoreServicesUIAgent"
        tell window 1
          tell (first button whose name starts with "use")
            perform action "AXPress"
          end tell
        end tell
      end tell
    end tell
  end try
end run

# Speech History

Speech History is a Hammerspoon moduel that allows you to navigate through recent Voice Over announcements and copy them to the clipboard.

## Installation

First, download and install Hammerspoon. You can do so either [from their Github](https://github.com/Hammerspoon/hammerspoon/releases/latest), or if you have it installed, through homebrew simply by running "brew install Hammerspoon" in the terminal. Once you have it installed, run it, and follow the prompts to grant accessibility permissions (I also choose to hide the app from the dock here so it stays out of your command-tab switcher)

You also need to allow external apps to control VoiceOver through Apple Script. To do so, open VoiceOver utility with VO + f8, navigate to the "General" section and check the "Allow VoiceOver to be controlled with AppleScript" checkbox.

Once Hammerspoon is installed and configured, navigate into the folder where you cloned this repository with Finder or another file manager, and open "SpeechHistory.spoon" which should cause Hammerspoon to install it into the right place. Finally, from the Hammerspoon menu extra select the open configuration option which should open your default text editor with your init.lua file. To make SpeechHistory work and do its thing, simply add the following 2 lines:
```lua
hs.loadSpoon("SpeechHistory")
spoon.SpeechHistory:start()
```

Save the file, return to the Hammerspoon menu extra but this time click the reload configuration option for your new changes to take effect. Mac OS will warn you that Hammerspoon is trying to control Voice Over. Grant it permission and the spoon should start working.


## Hotkeys

| Command | Description |
| --- | --- |
| Control+Shift+F11 | Go to Previous item |
| Control+Shift+F12 | Go to Next item |
| Control+Shift+Command+F11 | Go to First item |
| Control+Shift+Command+F12 | Go to Last item |

There's no special hotkey to copy the currently focused message, Vo + Shift + c is enough.

## Credits

Overal code structure and installation instructions taken from [Indent Beeper](https://github.com/pitermach/IndentBeeper)
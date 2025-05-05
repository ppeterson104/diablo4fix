# diablo4fix
Fix for the Windows version of Diablo IV that prevents the client from locking up on load

This fix was created based on information found in this thread:
https://us.forums.blizzard.com/en/d4/t/known-solutions-for-freeze-on-login-screen/212889

Credit to user ontheleft for figuring this out.

This Powershell script essentially just automates the process of removing the DisplayModeHeight and DisplayModeWidth values from the LocalPrefs.txt file. There are some other steps in there, but mostly just checks for OS architecture and whether or not the game is actually installed.

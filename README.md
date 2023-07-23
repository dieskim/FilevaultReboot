# FilevaultReboot
A simple MacOS Menu Bar app that allows you to initiate a FileVault Restart. This app allows for easier / more automated “fdesetup authrestart” by simply supplying your password. 

This is especially useful for remotely managed systems that you want to reboot, that have FileVault enabled since it will allow the Mac to reboot and be managed after reboot.

Provided as Open Source for Security of the end user. Any Support appreciated.

<a href="https://www.buymeacoffee.com/dieskim" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>

![How Shuttle works](https://raw.githubusercontent.com/dieskim/FilevaultReboot/main/Distribution/FilevaultReboot.gif)

## Installation

1. Download latest DMG from the FilevaultReboot [releases](https://github.com/dieskim/FilevaultReboot/releases)
2. Open the DMG
3. Move FilevaultReboot to Applications
4. Open FilevaultReboot App
5. Click on the FilevaultReboot Menu Bar Icon and enter you password. Your Mac will perform a Filevault Restart.

**Sidenote**: *As this app is not Sandboxed (Sandbox apps cant run terminal commands) and it asks for your password it has been released as Open Source for the end users security.  This is app is super simple (125 lines) and the bulk of the code can be viewed [here](https://github.com/dieskim/FilevaultReboot/blob/main/FilevaultReboot/ContentView.swift). Any Support appreciated.*

<a href="https://www.buymeacoffee.com/dieskim" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>

## License

This project is licensed under the terms of the [GNU General Public License version 3.0 (GPL-3.0)](https://www.gnu.org/licenses/gpl-3.0.en.html).

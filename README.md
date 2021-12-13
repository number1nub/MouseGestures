Mouse Gestures
==============

Perform custom actions when a specified gesture is input with the mouse. Actions include sending mouse/keyboard inputs, running applications, executing macros and more.

Changelog
---------

### 3.2.4
- [Fixed] Update URL encoding
- [Changed] Update will now always download the compiled EXE

### 3.2.0
- Moved to VS Code setup for source, build & versioning
- Fixed bad version on last release

### 3.1.2
- [Fixed] Compiled version unreliable (compression?)

### 3.1.1
- [Fixed] Tray menu tooltip wasn't updating
- [Fixed] RegPath was wrong in ShowTTtoggle
- [Changed] Moved version assignment to GetConfig
- [Changed] Created a ConfigTemplate function to house the hard-coded template

### 3.1.0
- [Changed] Updater will attempt to update to compiled file is current file is an EXE
- [Added] Display version & admin status in traytip

### 3.0.2
- [Changed] Version uses compiled file version if applicable

### 3.0.1
- [Changed] Removed MGR_UDF file and split all functions to library
- [Changed] Consolidated auto_version to config
- [Added] Tray menu item to open config INI file.
- [Added] Double click tray icon to open config file

### 2.1.0
- [Changed] Moved multiple functions that were being reused to global Lib

### 1.1.2
- Restructured and cleaned up code
- Moved startup logic into GetConfig & RegisterHotkeys functions

### 1.1.0
- Working upload

### 1.01.1
- Initial upload 2015-05-15
- Regular RButton send not working

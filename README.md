# libinput-gestures
A small script to read from libinput-debug-events and trigger key commands depending on recognized gestures. Libinput actually does all the hard work tracking the input and recognizing gestures, it just doesn't do anything with these other than outputting them. This script is kind of a missing link to put libinput's gesture recognition to good use, until there is proper support in GNOME etc.

DISCLAIMER: This is a script I made for myself because no other method (touchegg, xswipe, synaptics-driver etc.) seemed to work on my Dell XPS 13 (late 2015) running Fedora 23. It works for me and should work for any libinput based desktop environment aswell, but your milage may vary.

## Gestures
These are just the default settings, you can customize them at the start of the gestures.sh script.

### 3 finger gestures
- Right: Back (Alt+Left)
- Left: Forward (Alt+Right)
- Up: Overview (Super)
- Down: Show desktop (Super+D)

### 4 finger gestures
- Right: Move window to the right (Super+Right)
- Left: Move window to the left (Super+Left)
- Up: Maximize window (Super+Up)
- Down: Minimize window (Super+Down)

## Prerequisites
The script depends on the following executables beeing available in your PATH:
- libinput-debug-events
- xdotool

Please check your preferred search engine for how to install them. Since the script depends on xdotool, it probably won't work with wayland.

## Usage
Run the following command (with root privileges):
```
./gestures.sh
```

## Installation (start at boot)
Currently this depends on gdm and your UID beeing 1000, but you can probably change that in the gestures.service file if need be.

Run the following commands (with root privileges):
```
cp gestures.sh /usr/bin/gestures
cp gestures.service /usr/lib/systemd/system/
systemctl enable gestures.service
```

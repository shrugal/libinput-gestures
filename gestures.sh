#!/bin/bash

declare -A keys

# 3 finger gestures
keys[3+right]=alt+Left
keys[3+left]=alt+Right
keys[3+up]=super
keys[3+down]=super+d

# 4 finger gestures
keys[4+right]=super+Right
keys[4+left]=super+Left
keys[4+up]=super+Up
keys[4+down]=super+Down

# Some helpers
max () {
    if (( $(bc <<< "$2 > $1") )); then echo $2; else echo $1; fi
}

min () {
    if (( $(bc <<< "$2 < $1") )); then echo $2; else echo $1; fi
}

# Pointer state
dx=0
dy=0
dist=0
rot=0
regex_pos="(-?[0-9]+\.[0-9]+)/[[:space:]]?(-?[0-9]+\.[0-9]+)"
regex_rot="(-?[0-9]+\.[0-9]+)[[:space:]]?@[[:space:]]?(-?[0-9]+\.[0-9]+)"

# Main loop
while read line; do
    i=($line)
    action=${i[1]}
    fingers=${i[3]}

    case $action in
        "GESTURE_SWIPE_BEGIN")
            dx=0
            dy=0
            ;;

        "GESTURE_SWIPE_UPDATE")
            [[ $line =~ $regex_pos ]]
            dx=${BASH_REMATCH[1]}
            dy=${BASH_REMATCH[2]}
            ;;

        "GESTURE_SWIPE_END")
            ax=${dx#-}
            ay=${dy#-}
            
            ma=$(max $ax $ay)
            mi=$(min $ax $ay)

            # Make sure the gesture is clear
            if (( $(bc <<< "($ma < 10) || ($mi != 0 && $ma/$mi < 2)") )); then
                continue
            fi

            # Calculate direction
            if (( $(bc <<< "$ax > $ay") )); then
                if (( $(bc <<< "$dx > 0") )); then
                    dir="right"
                else
                    dir="left"
                fi
            else
                if (( $(bc <<< "$dy > 0") )); then
                    dir="down"
                else
                    dir="up"
                fi
            fi

            key="$fingers+$dir"
            #echo $DISPLAY
            #echo $XAUTHORITY
            xdotool key ${keys[$key]}
            ;;

        "GESTURE_PINCH_BEGIN")
            # TODO
            ;;
        
        "GESTURE_PINCH_UPDATE")
            # TODO
            ;;
    esac
done < <(stdbuf -oL libinput-debug-events &)

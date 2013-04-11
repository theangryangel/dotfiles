#!/bin/bash

# desired settings
x264preset=ultrafast
x264crf=0
fps=30

# find the window we want
xwin=`xwininfo`
xabs=$(echo "$xwin" | grep "Absolute upper-left X" | awk '{print $4}')
yabs=$(echo "$xwin" | grep "Absolute upper-left Y" | awk '{print $4}')
width=$(echo "$xwin" | grep "Width" | awk '{print $2}')
height=$(echo "$xwin" | grep "Height" | awk '{print $2}')

dims=$width"x"$height
offset=$xabs","$yabs

# record screen
ffmpeg \
-f alsa -ac 1 -i pulse \
-f x11grab -r $fps -s $dims -i :0.0+$offset \
-acodec libmp3lame \
-vcodec libx264 -preset $x264preset -crf $x264crf -threads 0 ~/output.mkv

# record secondary audio
#parec --format=s16le --rate=44100 -d ... | ffmpeg -ac 2 -f s16le -ar 44100  -i - mic.mp3

#parec --format=s16le --rate=44100 -d alsa_input.usb-Logitech_Logitech_USB_Headset-00-Headset.analog-mono | ffmpeg -ac 2 -f s16le -ar 44100  -i - ~/mic.mp3

# vim: set ts=4 sw=4 tw=80 :

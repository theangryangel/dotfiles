#!/bin/sh

SHRED=/usr/bin/shred

if [ $# -ne 1 ] ; then
    echo Not enough arguments!
    echo $0 /path/to/dir/contents/to/shred
    exit
fi

echo Shredding...
find $1 -maxdepth 3 -type f -print -execdir shred -n 3 -z {} \;


#!/bin/bash

usage() {
        echo "usage: $0 [options]"
		echo "Options: "
		echo "  -w <n-hours>  Wake in n-hours after suspend"
        exit 0
}

hours=0

while getopts "hw:" o; do
        case "${o}" in
                w)
                        hours=${OPTARG}
                        ;;
                *)
                        usage
                        ;;
        esac
done

echo 0 > /sys/class/rtc/rtc0/wakealarm
if [ $hours -gt 0 ]; then
        echo "Waking at `date '+%F %R' -d "+ $hours hours"`"
        echo `date '+%s' -d "+ $hours hours"` > /sys/class/rtc/rtc0/wakealarm
fi
echo "Suspending..."
/usr/sbin/pm-suspend

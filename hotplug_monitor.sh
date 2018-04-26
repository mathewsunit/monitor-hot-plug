#! /usr/bin/bash

export DISPLAY=:0.0
export XAUTHORITY=/home/sunit/.Xauthority

echo `date` >> /home/sunit/monitor.log 


function edp1_dp1_hdmi1(){
echo "Everything" >> /home/sunit/monitor.log
xrandr --output DP-1 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal --output eDP-1 --mode 1366x768 --pos 3840x0 --rotate normal --output HDMI-2 --off
}

function dp1_hdmi1(){
echo "Lid Down" >> /home/sunit/monitor.log
xrandr --output DP-1 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal --output eDP-1 --off --output HDMI-2 --off
}
 
function dp1(){
echo "Just VGA" >> /home/sunit/monitor.log
xrandr --output DP-1 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI-1 --off --output eDP-1 --off --output HDMI-2 --off
}

function hdmi1(){
echo "Just HDMI" >> /home/sunit/monitor.log
xrandr --output HDMI-1 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-1 --off --output eDP-1 --off --output HDMI-2 --off
}

function edp1(){
echo "No External" >> /home/sunit/monitor.log
xrandr --output DP-1 --off --output HDMI-1 --off --output eDP-1 --mode 1366x768 --pos 3840x0 --rotate normal --output HDMI-2 --off
}

[ "$(cat /sys/class/drm/card0-DP-1/status)" = "disconnected" ] && dp1_connected=false || dp1_connected=true
[ "$(cat /sys/class/drm/card0-HDMI-A-1/status)" = "disconnected" ] && hdmi1_connected=false|| hdmi1_connected=true
[ "$(grep open /proc/acpi/button/lid/LID0/state)" = "state:      open" ] && edp1_connected=true || edp1_connected=false

echo $dp1_connected >> /home/sunit/monitor.log &
echo $hdmi1_connected >> /home/sunit/monitor.log & 
echo $edp1_connected >> /home/sunit/monitor.log &

if [ $dp1_connected = "true" -a $hdmi1_connected = "true" -a $edp1_connected = "true" ]; then
  edp1_dp1_hdmi1	
elif [ $dp1_connected = "true" -a $hdmi1_connected = "true" ]; then
  dp1_hdmi1
elif [ $dp1_connected = "true" ]; then
  dp1
elif [ $hdmi1_connected = "true" ]; then
  hdmi1
elif [ $edp1_connected = "true" ]; then
  edp1
else 
  exit
fi

/home/sunit/.config/polybar/launch-openbox.sh &
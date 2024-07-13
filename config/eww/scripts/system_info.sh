#!/bin/bash

get_con_status() {
  if [ "$(nmcli g | awk '{print $1}' | grep connected)" == "connected" ]; then
    echo "connected"
  else
    echo "disconnected"
  fi
}

get_ssid() {
  ssid=$(nmcli device show | grep GENERAL.CONNECTION | grep -v -E "\slo$")
  echo $(echo $ssid | awk 'NR == 1 {print $2}')
}

toggle() {
  conName=$(nmcli con show | grep -v -E "^lo\s" | awk 'NR == 2 {print $1}')

  if [ "$(get_con_status)" == "connected" ]; then
    nmcli con down $conName
  else
    nmcli con up $conName
  fi
}

get_volume() {
  volume=$(amixer get Master | awk -F'[][]' 'END{print $2}')
  echo "$volume"
}

get_brightness() {
  if [ -f /sys/class/backlight/*/brightness ]; then
    current=$(cat /sys/class/backlight/*/brightness)
    max=$(cat /sys/class/backlight/*/max_brightness)
    brightness=$(awk "BEGIN {printf \"%.0f\", ($current / $max) * 100}")
    echo "${brightness}"
  else
    echo "Unable to determine"
  fi
}

get_bluetooth() {
  if command -v bluetoothctl &>/dev/null; then
    bt_status=$(bluetoothctl info | grep "Connected:" | awk '{print $2}')
    if [ "$bt_status" == "yes" ]; then
      bt_device=$(bluetoothctl info | grep "Name:" | cut -d':' -f2 | xargs)
      echo "${bt_device}"
    else
      echo "Disconnected"
    fi
  else
    echo "bluetoothctl not available"
  fi
}

get_battery() {
  if [ -d "/sys/class/power_supply/BAT0" ]; then
    capacity=$(cat /sys/class/power_supply/BAT0/capacity)
    status=$(cat /sys/class/power_supply/BAT0/status)
    if [ "$status" = "Charging" ]; then
      echo "‎ Plugged-In ${capacity}"

    else
      echo "‎ On-Battery ${capacity}"
    fi
  else
    echo "No battery found"
  fi
}

case "$1" in
--get_ssid)
  get_ssid
  ;;
--get_volume)
  get_volume
  ;;
--get_brightness)
  get_brightness
  ;;
--get_bluetooth)
  get_bluetooth
  ;;
--get_battery)
  get_battery
  ;;
*)
  echo "Usage: $0 {--get_ssid|--get_volume|--get_brightness|--get_bluetooth|--get_battery}"
  exit 1
  ;;
esac

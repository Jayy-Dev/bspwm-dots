#!/bin/bash

# Function to check WiFi status
check_wifi() {
  if nmcli radio wifi | grep -q "enabled"; then
    echo "On"
  else
    echo "Off"
  fi
}

# Function to check Bluetooth status
check_bluetooth() {
  if bluetoothctl show | grep -q "Powered: yes"; then
    echo "On"
  else
    echo "Off"
  fi
}

# Function to check microphone status
check_mic() {
  if amixer get Capture | grep -q "\[on\]"; then
    echo "On"
  else
    echo "Off"
  fi
}

# Function to toggle WiFi
toggle_wifi() {
  if nmcli radio wifi | grep -q "enabled"; then
    nmcli radio wifi off
  else
    nmcli radio wifi on
  fi
}

# Function to toggle Bluetooth
toggle_bluetooth() {
  if bluetoothctl show | grep -q "Powered: yes"; then
    rfkill block bluetooth
  else
    rfkill unblock bluetooth
  fi
}

# Function to toggle microphone
toggle_mic() {
  if amixer get Capture | grep -q "\[on\]"; then
    amixer set Capture nocap
  else
    amixer set Capture cap
  fi
}

# Command-line option handling
case "$1" in
--check_wifi)
  check_wifi
  ;;
--check_bluetooth)
  check_bluetooth
  ;;
--check_mic)
  check_mic
  ;;
--toggle-wifi)
  toggle_wifi
  ;;
--toggle-bluetooth)
  toggle_bluetooth
  ;;
--toggle-mic)
  toggle_mic
  ;;
*)
  echo "Usage: $0 {--check_wifi|--check_bluetooth|--check_mic|--toggle-wifi|--toggle-bluetooth|--toggle-mic}"
  exit 1
  ;;
esac

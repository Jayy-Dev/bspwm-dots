#!/bin/bash

EWWPATH="$HOME/.config/eww/popup/"

case "$1" in
--toggle-powermenu)
  /usr/bin/eww open powermenu --toggle --config "$EWWPATH"
  ;;
--toggle-dashboard)
  /usr/bin/eww open control-center --toggle --config "$EWWPATH"
  ;;
--toggle-music)
  /usr/bin/eww open music --toggle --config "$EWWPATH"
  ;;
esac

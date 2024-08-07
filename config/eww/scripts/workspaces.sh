#!/bin/bash

######################################################################
# You need to install wmctrl, xdotool and nerd-font
######################################################################

# Japanese numbers array
japanese_numbers=("一" "二" "三" "四" "五" "六" "七" "八" "九" "十")

# Return "occupied" only if currently workspaces was occupied
check_occupied() {
  wmctrl -l | awk '{print $2}' | while read -r occupied; do
    if [ "$occupied" == "$1" ]; then
      echo "occupied"
      return
    fi
  done
}

# Create yuck code of the currently workspaces status
get_workspaces_yuck() {
  buffered=""
  status_class=""

  # Before read this section you better execute 'wmctrl -d / -l'
  wmctrl -d | awk '{print $1 " " $2 " " $9}' | while read -r number status name; do

    occupied=$(check_occupied $number)

    if [ "$status" == "-" ]; then # "-" mean inactive
      status_class="workspace_inactive"
      icon="${japanese_numbers[$number]}"
    fi

    if [ "$occupied" == "occupied" ]; then
      status_class="workspace_occupied"
      icon="${japanese_numbers[$number]}"
    fi

    if [ "$status" == "*" ]; then # "*" mean active
      status_class="workspace_active"
      icon="${japanese_numbers[$number]}"
    fi

    buffered+=$'\n'
    buffered+="(label :class '$status_class' :text '$icon')"

    if [ "$number" == "$1" ]; then
      echo "$buffered"
    fi
  done
}

get_activewindow() {
  windowName=$(xdotool getwindowfocus getwindowname)

  if [ "$windowName" == "" ]; then
    echo "inactive"
  else
    echo "$windowName"
  fi
}

# Main
if [ "$1" == "--workspaces_yuck" ]; then
  ewwStructure="box :spacing 10"

  workspacesNumber=$(wmctrl -d | awk '{print $1}' | tail -c 2)
  workspacesStatus=$(get_workspaces_yuck $workspacesNumber)

  echo "($ewwStructure $workspacesStatus)"

elif [ "$1" == "--activewindow" ]; then
  get_activewindow
fi

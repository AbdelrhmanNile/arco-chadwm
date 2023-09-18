#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/arco-chadwm/scripts/bar_themes/dracula

cpu() {
  #cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)
  # echo ""$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%"
  cpu_perc="$((100-$(vmstat 1 2|tail -1|awk '{print $15}')))"

  printf "^c$black^ ^b$darkblue^ CPU"
  printf "^c$white^ ^b$grey^ $cpu_perc%%"
}

pkg_updates() {
  updates=$(checkupdates | wc -l)   # arch

  if [ -z "$updates" ]; then
    printf "  ^c$green^    Fully Updated"
  else
    printf "  ^c$green^    $updates"" updates"
  fi
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
  get_status="$(cat /sys/class/power_supply/BAT0/status)"

  if [ "$get_status" = "Charging" ]; then
    printf "^c$green^   $get_capacity"
  else
    printf "^c$blue^   $get_capacity"
  fi
}

brightness() {
  printf "^c$red^   "
  printf "^c$red^%.0f\n" $(xbacklight)
}

mem() {
  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$darkblue^  "
	printf "^c$black^^b$blue^ $(date '+%d/%m/%y %I:%M %p')  "
}

sep() {
  printf "^c$black^ ^b$black^"
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 2 && xsetroot -name "$(battery) $(brightness) $(cpu) $(mem) $(clock)"
done

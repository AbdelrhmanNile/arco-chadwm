#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/arco-chadwm/scripts/bar_themes/rosepine_moon

cpu() {
  cpu_perc="$((100-$(vmstat 1 2|tail -1|awk '{print $15}')))"

  printf "^c$black^ ^b$rose^ CPU"
  printf "^c$white^ ^b$hl^  $cpu_perc%% "
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
    printf "^c$black^^b$gold^   "
    printf "^c$white^^b$hl^  $get_capacity%% "
  else
    if [ $get_capacity -gt 90 ]; then
      printf "^c$black^^b$green^   "
    elif [ $get_capacity -lt 90 ] && [ $get_capacity -gt 60 ]; then
      printf "^c$black^^b$green^   "
    elif [ $get_capacity -lt 60 ] && [ $get_capacity -gt 40 ]; then
      printf "^c$black^^b$green^   "
    elif [ $get_capacity -lt 40 ] && [ $get_capacity -gt 25 ]; then
      printf "^c$black^^b$green^   "
    elif [ $get_capacity -lt 25 ] && [ $get_capacity -gt 15 ]; then
      printf "^c$black^^b$red^   "
    elif [ $get_capacity -lt 15 ] && [ $get_capacity -gt 0 ]; then
      printf "^c$black^^b$red^   "
    fi
    printf "^c$white^^b$hl^  $get_capacity%% "
  fi
}

brightness() {
  printf "^c$black^^b$red^   "
  printf "^c$white^^b$hl^  %.0f\n" $(xbacklight -get)
}

mem() {
  printf "^c$black^^b$blue^ MEM"
  printf "^c$white^ ^b$hl^  $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$darkblue^  "
	printf "^c$white^^b$hl^ $(date '+%d/%m/%y %I:%M %p') "
}

sep() {
  printf "^c$black^ ^b$black^"
}

while true; do


  sleep 2 && xsetroot -name "$(battery) $(brightness) $(cpu) $(mem) $(clock)"
done

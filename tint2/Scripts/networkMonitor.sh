logfile="${XDG_CACHE_HOME:-$HOME/.cache}/netlog"
prevdata="$(cat "$logfile")"

rxcurrent="$(($(cat /sys/class/net/*/statistics/rx_bytes | paste -sd '+')))"
txcurrent="$(($(cat /sys/class/net/*/statistics/tx_bytes | paste -sd '+')))"

printf "\uea92%sKiB \uea95%sKiB\\n" "$(((rxcurrent-${prevdata%% *})/1024))" "$(((txcurrent-${prevdata##* })/1024))"
	   
echo "$rxcurrent $txcurrent" > "$logfile"	   

#! /bin/bash

	#-------------------------------------------------------------------
	function getDate
	{
		date +'%A %d %B %Y, %H:%M'
	}

	#-------------------------------------------------------------------
	function getMemoryUsage
	{
		function print
		{
			function printInternal
			{
				out=$(awk "BEGIN {printf ($1)/$2}")
				out=${out//[.]/,}
				printf "  %."$3"\n" $out
			}


			if [ $(($1/1048576)) -gt 0 ]
			then
				printInternal $1 1048576 2fG
			else
				printInternal $1 1024 0fM
			fi
		}

		free=($(free))
		print $((${free[8]}+${free[10]}))
	}


	#-------------------------------------------------------------------
	#todo
	function getCpuUsage
	{
		echo  $(echo $[100-$(vmstat 1 2|tail -1|awk '{print $15}')])%
		#echo  $(echo $[100-$(vmstat|tail -1|awk '{print $15}')])%
	}


	#-------------------------------------------------------------------
	function getNetworkMonitor
	{
		mkdir ${HOME}"/.cache" 2> /dev/null
		logfile=${HOME}/.cache/netlog

		# create empty log if not exists
		cat "$logfile"> /dev/null || echo "0 0" > "$logfile"

		prevdata="$(cat "$logfile")"

		rxcurrent="$(($(cat /sys/class/net/*/statistics/rx_bytes | paste -sd '+')))"
		txcurrent="$(($(cat /sys/class/net/*/statistics/tx_bytes | paste -sd '+')))"

		printf "\uea92%sKiB/s \uea95%sKiB/s\\n" "$(((rxcurrent-${prevdata%% *})/(1024*5)))" "$(((txcurrent-${prevdata##* })/(1024*5)))"

		echo "$rxcurrent $txcurrent" > "$logfile"
	}

	#-------------------------------------------------------------------
	function getVolume
	{
		array=$(echo $(amixer get 'Master') | awk '{print $27 " " $26}')
		array=${array//['[',']']/}
		IFS=' ' read -r -a array <<< "$array"
		if [ ${array[0]} = "on" ];
		then
			echo -e '\ueea8' ${array[1]}
		else
			echo -e '\uecb8' mute
		fi
	}

#~ ---------------------------------------------------------------------
#~ to color text use span
#~ echo '<span foreground="red" background="black">text</span>'
#~ ---------------------------------------------------------------------

separator='<span> </span><span> </span><span> </span>'

output='<span foreground="#282a36"></span>'
output=${output}'<span foreground="#f8f8f2" background="#282a36">'
output=${output}'<span> </span>'
output=${output}$(getVolume)
output=${output}'<span> </span>'
output=${output}'</span>'

output=${output}'<span foreground="#6272a4" background="#282a36"></span>'
output=${output}'<span foreground="#f8f8f2" background="#6272a4">'
output=${output}'<span> </span>'
output=${output}$(getNetworkMonitor)
output=${output}'<span> </span>'
output=${output}'</span>'

output=${output}'<span foreground="#bd93f9" background="#6272a4"></span>'
output=${output}'<span foreground="#f8f8f2" background="#bd93f9">'
output=${output}'<span> </span>'
output=${output}$(getCpuUsage)
output=${output}'<span> </span>'
output=${output}'</span>'

output=${output}'<span foreground="#ffb86c" background="#bd93f9"></span>'
output=${output}'<span foreground="#282a36" background="#ffb86c">'
output=${output}'<span> </span>'
output=${output}$(getMemoryUsage)
output=${output}'<span> </span>'
output=${output}'</span>'

output=${output}'<span foreground="#f8f8f2" background="#ffb86c"></span>'
output=${output}'<span foreground="#282a36" background="#f8f8f2">'
output=${output}'<span> </span>'
output=${output}$(getDate)
output=${output}'<span> </span>'
output=${output}'</span>'

echo ${output}

# echo '<span foreground="#bd93f9"></span><span foreground="#f8f8f2" background="#bd93f9">text</span>'

#separator='<span> </span><span> </span><span> </span><span> </span>'
#echo -e $(getVolume)${separator}$(getNetworkMonitor)${separator}$(getCpuUsage)${separator}$(getMemoryUsage)${separator}$(getDate)

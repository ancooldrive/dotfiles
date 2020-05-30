str=$(amixer get 'Master')
enabled=$(echo ${str} | awk '{split($0,a," "); print a[27]}')
if [ ${enabled} = "[on]" ];
then
	volume=$(echo ${str} | awk '{split($0,a," "); print a[26]}')
	volume=${volume//[[]/}
	volume=${volume//[]]/}
	echo -e '\ueea8' ${volume}
else
	echo -e '\uecb8' mute
fi

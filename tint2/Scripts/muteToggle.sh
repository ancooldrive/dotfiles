str=$(amixer get 'Master')
enabled=$(echo ${str} | awk '{split($0,a," "); print a[27]}')
if [ ${enabled} = "[on]" ];
then
	$(amixer sset 'Master' off)
else
	$(amixer sset 'Master' on)
fi

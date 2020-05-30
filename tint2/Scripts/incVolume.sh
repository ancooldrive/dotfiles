test=$(~/.config/tint2/Scripts/getVolume.sh)
test=$((test+10))

if [ $test -gt 100 ] 
then
	test=100
fi

$(amixer sset 'Master' ${test}%)

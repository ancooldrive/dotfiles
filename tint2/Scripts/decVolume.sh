test=$(~/.config/tint2/Scripts/getVolume.sh)
test=$((test-10))

if [ $test -lt 0 ] 
then
	test=0
fi

$(amixer sset 'Master' ${test}%)

test=$(~/Dokumenty/test/getVolume.sh)
test=$((test-10))

if [ $test -lt 0 ] 
then
	test=0
fi

$(amixer sset 'Master' ${test}%)

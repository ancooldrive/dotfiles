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

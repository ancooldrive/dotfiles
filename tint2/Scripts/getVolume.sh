str=$(amixer get 'Master')
enabled=$(echo ${str} | awk '{split($0,a," "); print a[27]}')
volume=$(echo ${str} | awk '{split($0,a," "); print a[26]}')
volume=${volume//[[]/}
volume=${volume//[]]/}
volume=${volume//[%]/}
echo ${volume}

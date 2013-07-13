awk 'BEGIN { FS=RS }{ print length,$0 }'$* |
sort +0n -1 |
sed 's/^[0-9][0-9]*//'

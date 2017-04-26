#!/bin/bash
#Memory Check Script

Total_Memory=$( free | grep Mem: | awk '{print $2}')
memory=$( free | grep Mem: | awk '{print $3}')
percent=$(((100*memory)/Total_Memory))
echo $Total_Memory

while getopts ":c:w:e" param; do
case "$param" in

c)
	critical=${OPTARG}
	;;
w)
	warning=${OPTARG}
	;;
e)
	email=${OPTARG}
	;;
\?)
	echo "Invalid option: -$OPTARG" >&2
	;;
	esac

done

shift $((OPTIND-1))

date="$(date +'%Y%m%d %H:%M')"

if [ $warning -ge $critical ]
then
	echo "Error! -w -c -e (-w < -c). Email email@mine.com"
fi

if [ $percent -ge $critical ]
then
	echo "Critical at time:$date"
	exit 2
fi

if [ $percent -ge $warning ]
then
	echo "Warning at time:$date"
	exit 1
fi

if [ $percent -lt $warning ]
then
	echo "Stable at time:$date"
	exit 0

fi

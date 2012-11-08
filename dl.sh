#!/bin/sh

url="$1"

downloadedfilename="downloadedfile"

if [ "$url" == "" ]
then
	echo "Provide a url"
	exit -1
fi

chunks=10

length=$(curl -sI "$url" | awk -F':' '/Content-Length/ {print $2}' | egrep -o '[0-9]+')
chunksize=$(($length / 10))

count=0
start=0
end=$chunksize

while [ $count -lt $chunks ]
do
	curl -# -r ${start}-${end} "${url}" -o ${downloadedfilename}.$count > ${downloadedfilename}-$count.log 2>&1 &

	count=$(($count + 1))
	start=$(($end + 1))

	if [ $count -eq $((chunks - 1)) ]
	then
		end=""
	else
		end=$(($end + $chunksize))
	fi
done

wait

cat ${downloadedfilename}.* > ${downloadedfilename}
rm ${downloadedfilename}.* *.log

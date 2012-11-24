#!/bin/sh

url=$1
if [ "${url}" == "" ]
then
	echo "Provide a url"
	exit -1
fi

file=$(basename $(echo $url | sed -e 's/ /_/g'))
downloadedfilename="$file"
if [ "" == "$downloadedfilename" ]
then
	echo "Could not determine filename. Using downloadedfile as filename"
	downloadedfilename="downloadedfile"
fi

curl_path=$(which curl)
if [ "" == "$curl_path" ]
then
	echo "Looks like you are missing curl. You will need to install this"
	exit 1
fi

http_ver=$(curl -sI "$url" | grep '^HTTP' | sed -e 's/^HTTP\/\([12]\).*/\1/')
if [ $http_ver -eq 1 ]
then
	echo "HTTP version 1 detected. Can not segment the download"
	curl "$url" -o ${downloadedfilename}
	exit 0
fi

chunks=10

length=$(curl -sI "$url" | awk -F':' '/Content-Length/ {print $2}' | egrep -o '[0-9]+')
chunksize=$(($length / 10))

exit 1
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

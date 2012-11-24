# Curl Segmented Downloader

Very basic segmented downloader implemented using curl.

# Usage

#> dl.sh "<someurl>"

Will segment the download into 10 pieces and download each one concurrently.


# Known Issues

1. Script is too dumb at this point to detect the actual filename you are downloading so just creates a file called downloadefile instead which you will have to rename
2. Will not work if downloading from an HTTP 1.0 server and does not check for that yet so be warned
3. You really don't get much feedback from the script other than if you run tail -f downloadedfile-* and still it is pretty useless
4. Needs to be rewritten in something other than bash because of the various url's that could come as input

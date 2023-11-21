function jwtd() {
	local in=$1
	if [ -z "$in" ]
	then
	  read in
	fi
	jq -R 'split(".") | select(length > 0) | .[0:2] | map(gsub("_"; "/") | gsub("-"; "+") | @base64d | fromjson)' <<< $in
}
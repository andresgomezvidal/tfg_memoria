Get-ChildItem "$DIR" -Filter *.enc |
Foreach-Object {
	$file=$_.FullName
	$dfile=$file.substring(0,$file.length-4) #removes ".enc"
	."$openssl" enc -d -aes-256-cbc -in "$file" -out "$dfile" -pass pass:"$PASS"
}

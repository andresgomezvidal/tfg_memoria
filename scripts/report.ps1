$GPOfile="C:\Users\Public\Documents\report_GPResultantSetOfPolicy.xml"
#$ADDC is needed in case the computer running the command is not a DC of the AD
$ADDC=(Get-ADDomainController -Discover|findstr Name|Select-Object -last 2|Select-Object -first 1).split(':')[1].split(' ')[1]
(Get-GPResultantSetOfPolicy -Computer $ADDC -ReportType Xml -Path $GPOfile) | out-null

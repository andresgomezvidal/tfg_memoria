#https://gallery.technet.microsoft.com/scriptcenter/Get-WinEventData-Extract-344ad840
. C:\Users\Administrator\Downloads\Get-WinEventData.ps1

$Filenames = @()
$DIR='c:\temp'
$temp=(Get-Date).AddMinutes(-150)
$events=Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational"}| Get-WinEventData |  Where-Object{$_.Id -eq 2}| Where-Object{$_.EventDataTargetFilename -like "*$DIR*"} | Where-Object{$_.TimeCreated -ge $temp} | Select-Object EventDataTargetFilename
foreach($result in $events){
	$file=$result.EventDataTargetFilename
	if($Filenames -notcontains $file){
	    $Filenames += $file
	}
}

Get-ChildItem "$DIR" | 
Foreach-Object {
	$file=$_.FullName
	#creationtime is already checked with Sysmon
	if(($(Get-Item $file).lastaccesstime -gt $temp) -or ($(Get-Item $file).lastwritetime -gt $temp)){
		if($Filenames -notcontains $file){
		    $Filenames += $file
		}
	}
}

New-EventLog -LogName Application -Source TridEventLog #creates the log if it does not exist
foreach($file in $Filenames){
	$output='{"scanned_filename":"'
	$output+=$file
	$output+='", "scan_output":"'
	$out=C:\users\Administrator\Downloads\trid.exe $file | Select-Object -last 1
	$output+=$out
	$output+='"}'
	Write-EventLog -LogName Application -Source TridEventLog -EntryType Information -Message "$output" -EventId 1
}

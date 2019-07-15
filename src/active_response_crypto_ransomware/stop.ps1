#Process arguments
if($Args.length -eq 0){
	write-host "Essential arguments are missing: Path"
	exit 1
}

$directory=$Args[0]
$process_id=$Args[1]
if(-Not ([string]::IsNullOrEmpty($Args[2]))){
	$executable=$Args[2]
	$executable=$executable.replace('\\','/')
	$executable=$executable.replace('//','/')
	$executable_short=$executable.split('/')[-1]
	$kill_all=$Args[3]
}


# MITIGATION ACTIONS

#Disable the Internet adapter
$name=(Get-NetIPConfiguration| where-object{$_.IPv4Address.IPAddress -like '10.0.2.15'}).InterfaceAlias
Disable-NetAdapter -Name "$name" -Passthru  -Confirm:$false

#Kill process or processes
if(-Not ([string]::IsNullOrEmpty($process_id))){
	Stop-Process $process_id -Force
}

#Lock files recursively in each directory in $DIRS
$DIRS=@('c:\temp', 'c:\tmp')
if($DIRS -notcontains $directory){
	$DIRS+=$directory
}

$handleArray= @()
function recursive_lock {
	Param(
		[Parameter(Mandatory=$True)]
		[String] $folder
	)
	Get-ChildItem "$folder" -File | 
	Foreach-Object {
		$handle = [System.io.File]::Open($_.FullName, 'Open', 'Read', 'None')
		$handleArray+=$handle
	}
	Get-ChildItem "$folder" -Directory | 
	Foreach-Object {
		recursive_lock $_.FullName
	}
}
Foreach($DIR in $DIRS){
	recursive_lock $DIR
}


# PERIODIC ACTIONS

$seconds=20
$interval=10
for ($i=0; $i -lt $seconds; $i+=$interval) {
	if (($kill_all -eq 1) -or ($kill_all -eq $True)){
		(Stop-Process -Name $executable -PassThru -Force) -or (Stop-Process -Name $executable_short -Force)
	}
	Start-sleep -s $interval
}



# UNDO PREVIOUS ACTIONS

#Free file handles
Foreach($handle in $handleArray) {
	$handle.Close()
}

#Enable the Internet adapter disabled previously
Enable-NetAdapter -Name "$name" -Passthru  -Confirm:$false

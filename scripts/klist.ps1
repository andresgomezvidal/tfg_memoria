#this script parses in a json format the kerberos info that may identify a ticket used in a golden ticket attack

$newline=0 	#if 1 adds carriage return and line jump to each line instead of only after closing each json root


#get the value of MaxTicketAge (10 by default)
$GPOfile="C:\Users\Public\Documents\report_GPResultantSetOfPolicy.xml"
$GPO = Get-Content $GPOfile

$index=-1
for ($i = 0; $i -lt $GPO.length; $i++){
	if ($GPO[$i].Contains("MaxTicketAge")){
		$index=$i
		break
	}
}
if ($index -gt -1){
	$MaxTicketAge = $GPO[$index+1]
	$MaxTicketAge = $MaxTicketAge.split('>')[1].split('<')[0]
}else{
	$MaxTicketAge = 10
}


#get tickets for every session in the kerberos cache
$sessions = klist sessions
$output = ""
foreach ($line in $sessions){ 
	if ($line -match "^\[.*\]"){ 		#first line does not have an id
		$id = $line.split(' ')[3] 
		$id=$id.replace('0:','')
		$tickets = klist tickets -li $id
		if ($tickets -match "Error" -Or $tickets -match "failed" -Or $tickets.Contains("Cached Tickets: (0)")){
			continue
		}
	}elseif ([string]::IsNullOrEmpty($output)){
		$tickets = klist tickets 		#add this just once
	}else{
		continue
	}
	foreach ($ticket in $tickets){
		if (-Not ([string]::IsNullOrEmpty($ticket) -And [string]::IsNullOrWhiteSpace($ticket))){
			$ticket = $ticket -replace '^\s+',''
			$ticketJson = ''
			If ($ticket.Contains("Current LogonId")){
				$currentLogonIdJson = '"Current_LogonId": "'
				$ticket = $ticket -replace '^Current\sLogonId is 0:',''
				$currentLogonIdJson += $ticket
				$currentLogonIdJson += '",'
			}elseIf ($ticket.Contains("Targeted LogonId")){
				$targetedLogonIdJson = '"Targeted_LogonId": "'
				$ticket = $ticket -replace '^Targeted\sLogonId is 0:',''
				$targetedLogonIdJson += $ticket
				$targetedLogonIdJson += '",'
			}elseIf ($ticket.Contains("Cached Tickets")){
				continue
			}elseif($ticket -match "^#\d>\s"){
				$ticketJson += "{"
				if ($newline -eq 1) { $ticketJson += "`r`n" }
				$ticketJson += '"MaxTicketAge": "'
				$ticketJson += $MaxTicketAge
				$ticketJson += '",'
				if ($newline -eq 1) { $ticketJson += "`r`n" }
				$ticketJson += $currentLogonIdJson
				if ($newline -eq 1) { $ticketJson += "`r`n" }
				$ticketJson += $targetedLogonIdJson
				if ($newline -eq 1) { $ticketJson += "`r`n" }
				$ticketJson += '"Number": "'
				$ticketJson += $ticket.split('>')[0].split('#')[1]
				$ticketJson += '",'
				if ($newline -eq 1) { $ticketJson += "`r`n" }
				$ticket = $ticket.split('>')[1]
				$ticket = $ticket -replace '^\s+',''
				$ticketJson += '"'
				$ticketJson += $ticket.split(':')[0].replace(' ','_')
				$ticketJson += '": "'
				$ticketRest = $ticket -replace $ticket.split(':')[0],''
				$ticketRest = $ticketRest -replace '^:\s+',''
				$ticketJson += $ticketRest
				$ticketJson += '",'
			}elseIf ($ticket.Contains("Ticket Flags")){
				$ticketJson += '"Ticket_Flags": "'
				$ticketJson += $ticket -replace '^Ticket\sFlags ',''
				$ticketJson += '",'
			}elseIf ($ticket.Contains(":")){
				$ticketJson += '"'
				$ticketJson += $ticket.split(':')[0].replace(' ','_')
				$ticketJson += '": "'
				$ticketRest = $ticket -replace $ticket.split(':')[0],''
				$ticketRest = $ticketRest -replace '^:\s+',''
				$ticketJson += $ticketRest
				if ($ticketJson.Contains("Kdc_Called")){
					$ticketJson += '"'
					if ($newline -eq 1) { $ticketJson += "`r`n" }
					$ticketJson += "}"
				}elseif ($ticketJson.Contains("Start_Time")){
					$ticketJson += '",'
					[datetime]$startTime = $ticketRest.replace(' (local)','')
				}elseif ($ticketJson.Contains("End_Time")){
					$ticketJson += '",'
					[datetime]$endTime = $ticketRest.replace(' (local)','')
					if ($newline -eq 1) { $ticketJson += "`r`n" }
					$ticketJson += '"TicketExpireHours": "'
					[string]$diff = $endTime - $startTime
					if ($diff.Contains(".")){
						$diff = $diff.split('.')[0]
					}else{
						$diff = $diff.split(':')[0]
					}
					if ($diff.Contains("-")){
						$diff = $diff.split('-')[1]
					}
					$ticketJson += $diff
					$ticketJson += '",'
					if ($newline -eq 1) { $ticketJson += "`r`n" }
					$ticketJson += '"TicketExpireHoursGap": "'
					[int]$diff = $diff
					$ticketJson += $diff - $MaxTicketAge
					$ticketJson += '",'
				}else{
					$ticketJson += '",'
				}
			}
			$output += $ticketJson
			if ($newline -eq 1) { $output += "`r`n" }
		}
	}
	$output += "`r`n"
	if ($newline -eq 1) { $output += "`r`n`r`n" }
}

Write-Host $output

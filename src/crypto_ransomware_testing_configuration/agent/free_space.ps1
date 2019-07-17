$volume='F'
$results=fsutil volume diskfree ${volume}:
$output='{"backup_volume":"'
$output += $volume
$output +='", '
foreach ($line in $results){ 
	$label=$line.split(':')[0]
	$label=$label -replace ' # ','_' 
	$label=$label -replace '\s\s+','' 
	$label=$label -replace '\s','_' 
	$bytes=$line.split(':')[1].split('(')[0].substring(1)
	$bytes=$bytes.substring(0,$bytes.length-1)
	$output +='"'
	$output +=$label
	$output +='":"'
	$output +=$bytes
	$output +='", '
}
$output=$output.substring(0,$output.length-2) #remove the last ', '
$output +='}'
$output += "`r`n"
Write-Host $output

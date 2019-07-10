function Is-Numeric ($Value) {
    return $Value -match "^[\d\.]+$"
}
$nvalue=0
$value=0
$output='{'

$results=fsutil volume diskfree F:
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
	if ($label -eq 'Total_of_free_bytes'){
		$nvalue=$bytes
	}
}

$StorageFile="C:\storage\free_bytes_F.txt"
if(-not [System.IO.File]::Exists($StorageFile)){
	$value=0
}else{
	$content = Get-Content $StorageFile
	if((Get-Content C:\storage\free_bytes_F.txt | Measure-Object -Line).Lines -eq 1){
		if (Is-Numeric $content){
			$value=$content
		}else{
			$value=0
		}
	}else{
		$value=0
	}
}

if ($value -eq 0 -or $nvalue -lt $value){
	$nvalue| Out-File $StorageFile
}elseif ($nvalue -gt $value+10000){
	$nvalue| Out-File $StorageFile
	$output +='"Previous_value":"'
	$output +=$value
	$output +='"'
	$output +='}'
	$output += "`r`n"
	Write-Host $output
}

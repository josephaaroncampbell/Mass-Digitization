$rgbArray = Get-Content 'hist3.txt' | ForEach-Object { $_.Split(" ")[1] }; for( $i = 0; $i -lt ($rgbArray.Count - 1); $i++ ) {
  [int]$current = $rgbArray[$i]

  [int]$nextA1 = $rgbArray[$i + 1]
  [int]$nextA2 = $rgbArray[$i + 2]
  [int]$nextA3 = $rgbArray[$i + 3]
  [int]$nextA4 = $rgbArray[$i + 4]
  [int]$nextA5 = $rgbArray[$i + 5]
  [int]$nextA6 = $rgbArray[$i + 6]

  $rgbArray2 = Get-Content 'hist3.txt' | ForEach-Object { $_.Split(" ")[0] }; [int]$binNumber = $rgbArray2[$i]

  if( ($binNumber -ge 1) -And ($current -gt 2000) -And ($current -lt $nextA1) -And ($current -lt $nextA2) -And ($current -lt $nextA3) -And ($nextA1 -lt $nextA3)){
	
     [int]$minRGB = $binNumber
	 break
  }
}

$rgbArray = Get-Content 'hist3.txt' | ForEach-Object { $_.Split(" ")[1] }; for( $i = ($rgbArray.Count - 1); $i -gt 0; $i-- ) {
 
  [int]$current = $rgbArray[$i]
  [int]$nextA1 = $rgbArray[$i - 1]
  [int]$nextA2 = $rgbArray[$i - 2]
  [int]$nextA3 = $rgbArray[$i - 3]
  [int]$nextA4 = $rgbArray[$i - 4]
  [int]$nextA5 = $rgbArray[$i - 5]
  [int]$nextA6 = $rgbArray[$i - 6]

  $rgbArray2 = Get-Content 'hist3.txt' | ForEach-Object { $_.Split(" ")[0] }; [int]$binNumber = $rgbArray2[$i]

  if( ($current -ge 600) -And ($current -lt $nextA1) -And ($current -lt $nextA2) -And ($current -lt $nextA3) -And ($nextA1 -lt $nextA3)){

	 [int]$maxRGB = $binNumber
	 break
  }
}


$rgbArray = Get-Content 'hist3.txt' | ForEach-Object { $_.Split(" ")[1] }; for( $i = 0; $i -lt ($rgbArray.Count - 1); $i++ ) {

  [int]$current = $rgbArray[$i]
  [int]$next = $rgbArray[$i + 1]

        $rgbArray4 = Get-Content 'hist3.txt' | ForEach-Object { $_.Split(" ")[0] }; [int]$peakNumber = $rgbArray4[$i]

  if(($next -gt $current) -And ($peakNumber -lt $maxRGB)){
	$peakVal = $peakNumber
  }

}

return $peakVal

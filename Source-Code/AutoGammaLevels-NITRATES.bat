
setlocal enabledelayedexpansion

  ::moving to location of files provided to batch 
  CD /d "%~dp0"

  ::delete previous histogram and clut files
  del %~dp0hist.txt
  del %~dp0hist2.txt
  del %~dp0hist3.txt
  del %~dp0clut.tif
  
  ::create base linear grandient for clut
  magick  -size 1x256 gradient: -colorspace LAB -channel R -separate  -rotate 90 gscale.tif

  CD /d "%~dp1"

  echo ARE THESE CORRECT?
  echo      SOURCE = %cd%
  echo DESTINATION = %~dp0complete
  set source=%cd%

pause

  FOR /R %~dp1 %%a IN (*.tif) DO (
    call :dequote %%a
  )
 
  :dequote
  set fileName=%~n1
  set fileExt=%~x1
  set fullPath=%~f1
  set folderPath=%~dp1
  set name=%fileName%& set ext=%fileExt%
  for %%a in (%folderpath%) do for %%b in ("%%~dpa\.") do set "parentFolder=%%~nxb"
  
  echo fullPath = %fullPath%
  echo folderPath = %folderPath%
  echo parentFolder = %parentFolder%
  echo filename = %fileName%

  ::create clut file from gscale
  magick -quiet %~dp0gscale.tif -colorspace gray %~dp0clut.tif

  ::find mean and sigma of current image
  for /f "usebackq" %%f in (`magick convert -quiet !fullPath! -colorspace gray -gravity center -crop 60%% -precision 3 -format "MeanAx=%%[fx:mean*256]\nMaxAx=%%[fx:maxima*256]\nlumAx=%%[fx:luminance*256]\nDummyVal=%%[fx:15*1]" +write info:`) do (set %%f)

  set g=g1

		::create gamma correction value
		for /f "usebackq" %%c in (`magick identify -precision 3 -format "gNum=%%[fx:abs((80 + (128 - !meanAx!))/100)]\nboolgNum=%%[fx:(80 + (128 - !meanAx!))/100 <= 0.3]\nboolgNum256=%%[fx:(80 + (128 - !meanAx!))/100 <= 0.3 && !maxAx! >= 250]" xc:`) do (set %%c)

					IF !boolgNum! == 1 (
				   		for /f "usebackq" %%c in (`magick identify -precision 3 -format "gNum=%%[fx:0.6 - (!maxAx!/256)*0.3]" xc:`) do (set %%c)
						set g=g2
					)
					IF !boolgNum256! == 1 (
				   		for /f "usebackq" %%c in (`magick identify -precision 3 -format "gNum=%%[fx:0.7 - (!maxAx!/256)*0.3]" xc:`) do (set %%c)
						set g=g3
					)

   ::create histogram data and output to text file
    magick  -quiet !fullpath! %~dp0clut.tif -clut -colorspace gray -gamma !gNum! -gravity center -crop 60%% -format %%c histogram:info:- >> %~dp0hist.txt

			  CD /d "%~dp0"

			  ::edit histogram text file to remove unwanted characters using Powershell
			  Powershell.exe -Command "& Get-Content hist.txt | ForEach-Object { $_ -replace '\( ', '' } | ForEach-Object { $_ -replace '\(', '' } | ForEach-Object { $_ -replace ',', ' ' } | ForEach-Object { $_ -replace ':', '' } | Set-Content hist2.txt"
  
				 ::save first and second values from each line of histogram text file into respective variables
				 for /f "tokens=1-2" %%A in (%~dp0hist2.txt) do (
					set binCount=%%A
					set rgbValue=%%B
					echo !rgbValue! !binCount! >> %~dp0hist3.txt
				 )

						::load histogram data into array and find first ramp from max value via powershell script
						for /f "usebackq" %%c in (`PowerShell.exe -ExecutionPolicy Bypass -File %~dp0getMax.ps1`) do (set max=%%c)
						  echo max = %max%

						for /f "usebackq" %%c in (`PowerShell.exe -ExecutionPolicy Bypass -File %~dp0getPeak.ps1`) do (set peak=%%c)
						  echo peak = %peak%
					   
						for /f "usebackq" %%c in (`PowerShell.exe -ExecutionPolicy Bypass -File %~dp0getMin.ps1`) do (set min=%%c)
						  echo min = %min%
						  

				::calculate sigmoidal contrast pivot value and contrast amount			  
				for /f "usebackq" %%c in (`magick identify -precision 3 -format "sNum=%%[fx:(((!max! + !min! + !peak!) / 3) / 256) * 100]\nlNum=%%[fx: 1.2 + (log(!min!))]" xc:`) do (set %%c)
						
 
::delete previous histogram and clut files
 del %~dp0hist.txt
 del %~dp0hist2.txt
 del %~dp0hist3.txt

			  ::create histogram data and output to text file
			  magick -quiet !fullpath! %~dp0clut.tif -clut -colorspace gray -gamma !gNum! -sigmoidal-contrast 2x!sNum!%% -gravity center -crop 60%%  -format %%c histogram:info:- >> %~dp0hist.txt

			  ::edit histogram text file to remove unwanted characters using Powershell
			  Powershell.exe -Command "& Get-Content hist.txt | ForEach-Object { $_ -replace '\( ', '' } | ForEach-Object { $_ -replace '\(', '' } | ForEach-Object { $_ -replace ',', ' ' } | ForEach-Object { $_ -replace ':', '' } | Set-Content hist2.txt"
  
				 ::save first and second values from each line of histogram text file into respective variables
				 for /f "tokens=1-2" %%A in (%~dp0hist2.txt) do (
					set binCount=%%A
					set rgbValue=%%B
					echo !rgbValue! !binCount! >> %~dp0hist3.txt
				 )

					::load histogram data into array and find first ramp from max value via powershell script
					for /f "usebackq" %%c in (`PowerShell.exe -ExecutionPolicy Bypass -File %~dp0getMax.ps1`) do (set max2=%%c)
					  echo max2 = %max2%

					for /f "usebackq" %%c in (`PowerShell.exe -ExecutionPolicy Bypass -File %~dp0getPeak.ps1`) do (set peak2=%%c)
					  echo peak2 = %peak2%
					   
					for /f "usebackq" %%c in (`PowerShell.exe -ExecutionPolicy Bypass -File %~dp0getMin.ps1`) do (set min2=%%c)
					  echo min2 = %min2%
 
						  for /f "usebackq" %%c in (`magick identify -precision 3 -format "boolMean=%%[fx: !meanAx! <= 50 ]" xc:`) do (set %%c)

						  IF !boolMean! == 0 (
							for /f "usebackq" %%c in (`magick identify -precision 3 -format "lMax2=%%[fx:(!max2!/256)*100]\nlMin2=%%[fx: ((!min2!/256)*100) - (!min2!/10)) ]" xc:`) do (set %%c)
						  )

						  IF !boolMean! == 1 (
							for /f "usebackq" %%c in (`magick identify -precision 3 -format "lMax2=%%[fx:(!max2!/256)*100]\nlMin2=%%[fx: ((!min2!/256)*100)]" xc:`) do (set %%c)	
						  )

  
magick -quiet %~dp0gscale.tif -colorspace gray -gamma !gNum! -sigmoidal-contrast !lNum!x!sNum!%% -level !lMin2!%%x!lMax2!%% %~dp0clut.tif
magick -quiet !fullpath! %~dp0clut.tif -clut -colorspace gray %~dp0complete\!parentFolder!\!name!.tif
			
	   		   	  
::delete previous histogram and clut files
 del %~dp0hist.txt
 del %~dp0hist2.txt
 del %~dp0hist3.txt
 del %~dp0clut.tif 

	echo --!fileName!-!bool!--!g!---- >> %~dp0complete\nitrate-data.txt
	echo --------------------- >> %~dp0complete\nitrate-data.txt
	echo MeanAx = !MeanAx! >> %~dp0complete\nitrate-data.txt
	echo luminance = !lumAx! >> %~dp0complete\nitrate-data.txt
	echo maxAx = !maxAx! >> %~dp0complete\nitrate-data.txt
	echo gamma !g! = !gNum! >> %~dp0complete\nitrate-data.txt
	echo --------------------- >> %~dp0complete\nitrate-data.txt
	echo sNum = !sNum! >> %~dp0complete\nitrate-data.txt
	echo lNum = !lNum! >> %~dp0complete\nitrate-data.txt
	echo --------------------- >> %~dp0complete\nitrate-data.txt
	echo min = !Min! >> %~dp0complete\nitrate-data.txt
	echo min2 = !Min2! >> %~dp0complete\nitrate-data.txt
	echo lmin2 = !lMin2! >> %~dp0complete\nitrate-data.txt
	echo --------------------- >> %~dp0complete\nitrate-data.txt
	echo max = !Max! >> %~dp0complete\nitrate-data.txt
	echo max2 = !Max2! >> %~dp0complete\nitrate-data.txt
    echo lmax2 = !lMax2! >> %~dp0complete\nitrate-data.txt
	echo --------------------- >> %~dp0complete\nitrate-data.txt
	echo peak = !peak! >> %~dp0complete\nitrate-data.txt
	echo peak2 = !peak2! >> %~dp0complete\nitrate-data.txt
	echo --------------------- >> %~dp0complete\nitrate-data.txt

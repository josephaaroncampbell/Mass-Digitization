@echo off

CD /d "%~dp0ArchiveMasters

::create list of foldernames in ArchiveMaster child folder
dir /ad /b > %~dp0folderNameList.txt


  echo ARE THESE CORRECT?
  echo      SOURCE = %~dp0ArchiveMasters
  echo DESTINATION 1 = %~dp0Complete
  echo DESTINATION 2 = %~dp0ProductionMasters
  set source=%cd%
  pause  

echo create folder for each line of text file
  for /f %%n in (%~dp0folderNameList.txt) do (
    echo n=%%n
    mkdir %~dp0Complete\%%n
    mkdir %~dp0ProductionMasters\%%n
  )

del %~dp0folderNameList.txt
 

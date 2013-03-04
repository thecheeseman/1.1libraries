@echo off

set coddir=C:\Games\Call of Duty 1.1\main

cd ./code
7z a -tzip __11libraries.pk3 *
copy /Y __11libraries.pk3 "%coddir%\"
del __11libraries.pk3
cd ..
pause
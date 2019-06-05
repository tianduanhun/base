@echo off
setlocal EnableDelayedExpansion
set dir=%cd%
for /R ".\src\" %%s in (*.proto) do ( 
	set path=%%s
	set path=.!path:%dir%=!
	set pbPath=!path:~0,-6%!.pb
	set protoPath=!path!
	echo !pbPath!
	echo !protoPath!
	.\tool\protoc.exe --descriptor_set_out=!pbPath! !protoPath!
	echo ------------------------------------------------------
) 
pause
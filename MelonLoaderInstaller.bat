@echo off
setlocal enabledelayedexpansion

:: CONFIGURATION

:: Set this to true if you are using an unhollower over or equals to v0.3
set unhollower_over_03=false

:: If not empty, the installer will try to use these files rather than the online ones
set config_melonloader_zip=
set config_unhollower_zip=
::set config_unhollower_zip=Il2CppAssemblyUnhollower.0.3.1.0.7z

:: If not empty, the installer will install this zip and replace the existing files at the end of the install
::set config_postpatch_zip=MelonLoader0.1.1Patch.zip
set config_postpatch_zip=


:: CODE

CLS

set tlsfix=[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

echo:
echo [36m
echo /// POWERSHELL PROGRESS OUTPUT
echo /// POWERSHELL PROGRESS OUTPUT
echo /// POWERSHELL PROGRESS OUTPUT
echo /// POWERSHELL PROGRESS OUTPUT
echo [0m
echo ^    --------------------------------------------------
echo ^    ^|  MelonLoader AutoInstaller v1.4.2 by Slaynash  ^|
echo ^    ^|    - MelonLoader v0.1.0 by Herp Derpinstine    ^|
echo ^    ^|    - Il2CppDumper v6.2.1 by Perfare            ^|
echo ^    ^|    - Il2CppAssemblyUnhollower v0.2.0.0 by knah ^|
echo ^    --------------------------------------------------
echo:

echo [33m---------------------- Pre-Setup -----------------------[0m

IF NOT exist GameAssembly.dll (
	echo [31m
	echo It seems that this folder isn't an Il2Cpp Unity game.
	echo This installer only works for Unity installations.
	echo If you need help, please use the #melonloader-support channel
	echo of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
	echo [0m
	pause
	exit /B 2
)

for /f %%i in ('dir /b *_Data') do set data_folder=%%i

echo Cleaning up existing MelonLoader installation
IF EXIST MelonLoader rd /S /Q MelonLoader
IF EXIST winmm.dll del winmm.dll
echo:

echo Downloading 7zip...
%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell -Command "%tlsfix% Invoke-WebRequest https://github.com/Slaynash/MelonLoaderAutoInstaller/raw/master/7z.exe -OutFile 7z.exe"
%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell -Command "%tlsfix% Invoke-WebRequest https://github.com/Slaynash/MelonLoaderAutoInstaller/raw/master/7z.dll -OutFile 7z.dll"
echo:

echo [33m----------------- MelonLoader Install ------------------[0m

if not "%config_melonloader_zip%"=="" (
	if exist "%config_melonloader_zip%" (
		echo Using %config_melonloader_zip%.
	) else (
		echo [33mFile '%config_melonloader_zip%' not found. Falling back to online version.[0m
		set config_melonloader_zip=
	)
)

if "%config_melonloader_zip%"=="" (
	echo Downloading MelonLoader from github
	%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell -Command "%tlsfix% Invoke-WebRequest https://github.com/HerpDerpinstine/MelonLoader/releases/download/v0.1.0/MelonLoader.zip -OutFile melonloader.zip"
	if %errorlevel% neq 0 (
		echo [31m
		echo CRITICAL ERROR: Failed to download the MelonLoader zip file.
		echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
		echo [0m
		pause
		exit /b %errorlevel%
	)
)
echo Decompressing MelonLoader
if "%config_melonloader_zip%"=="" (
	7z x melonloader.zip -aoa
	del melonloader.zip
) else 7z x %config_melonloader_zip% -aoa
if %errorlevel% neq 0 (
	echo [31m
	echo CRITICAL ERROR: Failed to extract the MelonLoader zip file.
	echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
	echo [0m
	pause
	exit /b %errorlevel%
)
echo:

echo [33m------------------ Il2CppDumper Setup ------------------[0m

echo Downloading Il2CppDumper from github
%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell -Command "%tlsfix% Invoke-WebRequest https://github.com/Perfare/Il2CppDumper/releases/download/v6.2.1/Il2CppDumper-v6.2.1.zip -OutFile il2cppdumper.zip"
if %errorlevel% neq 0 (
	echo [31m
	echo CRITICAL ERROR: Failed to download the Il2CppDumper zip file.
	echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
	echo [0m
	pause
	exit /b %errorlevel%
)
echo Decompressing Il2CppDumper
7z x il2cppdumper.zip -oil2cppdumper -aoa
if %errorlevel% neq 0 (
	echo [31m
	echo CRITICAL ERROR: Failed to extract the Il2CppDumper zip file.
	echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
	echo [0m
	pause
	exit /b %errorlevel%
)
del il2cppdumper.zip
echo:

echo [33m------------ Il2CppAssemblyUnhollower Setup ------------[0m

if not "%config_unhollower_zip%"=="" (
	if exist "%config_unhollower_zip%" (
		echo Using %config_unhollower_zip%.
	) else (
		echo [33mFile '%config_unhollower_zip%' not found. Falling back to online version.[0m
		set config_unhollower_zip=
	)
)
if "%config_unhollower_zip%"=="" (
	echo Downloading Il2CppAssemblyUnhollower from github...
	%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell -Command "%tlsfix% Invoke-WebRequest https://github.com/knah/Il2CppAssemblyUnhollower/releases/download/v0.2.0.0/Il2CppAssemblyUnhollower.0.2.0.0.7z -OutFile il2cppassemblyunhollower.zip"
	if %errorlevel% neq 0 (
		echo [31m
		echo CRITICAL ERROR: Failed to download the Il2CppAssemblyUnhollower zip file.
		echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
		echo [0m
		pause
		exit /b %errorlevel%
	)
)
echo Decompressing Il2CppAssemblyUnhollower
if "%config_unhollower_zip%"=="" (
	7z x il2cppassemblyunhollower.zip -oil2cppassemblyunhollower -aoa
	del il2cppassemblyunhollower.zip
) else 7z x %config_unhollower_zip% -oil2cppassemblyunhollower -aoa
if %errorlevel% neq 0 (
	echo [31m
	echo CRITICAL ERROR: Failed to extract the Il2CppAssemblyUnhollower zip file.
	echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
	echo [0m
	pause
	exit /b %errorlevel%
)
echo:

echo [33m--------------- Il2CppDumper Generation ----------------[0m

echo Downloading Il2CppDumper config
%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell -Command "%tlsfix% Invoke-WebRequest https://github.com/Slaynash/MelonLoaderAutoInstaller/raw/master/il2cppdumper_config.json -OutFile il2cppdumper/config.json"
if %errorlevel% neq 0 (
	echo [31m
	echo CRITICAL ERROR: Failed to download the Il2CppDumper config file.
	echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
	echo [0m
	pause
	exit /b %errorlevel%
)
echo:

echo Running Il2CppDumper
cd il2cppdumper
Il2CppDumper.exe ..\GameAssembly.dll ..\%data_folder%\il2cpp_data\Metadata\global-metadata.dat
if %errorlevel% neq 0 (
	echo [31m
	echo CRITICAL ERROR: Failed to generate the assemblies using Il2CppDumper.
	echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
	echo [0m
	pause
	exit /b %errorlevel%
)
:: This move sometime fails due to permissions problems
::move DummyDll ..\il2cppdumper_output
cd ..
echo:

echo [33m--------- Il2CppAssemblyUnhollower Generation ----------[0m

mkdir il2cppassemblyunhollower_output

echo Running Il2CppAssemblyUnhollower
::il2cppassemblyunhollower\AssemblyUnhollower.exe --input=il2cppdumper_output --output=il2cppassemblyunhollower_output --mscorlib=MelonLoader\Managed\mscorlib.dll
if "%unhollower_over_03%"=="true" (
	il2cppassemblyunhollower\AssemblyUnhollower.exe --input=il2cppdumper/DummyDll --output=il2cppassemblyunhollower_output --mscorlib=MelonLoader\Managed\mscorlib.dll
) else (
	il2cppassemblyunhollower\AssemblyUnhollower.exe il2cppdumper/DummyDll il2cppassemblyunhollower_output MelonLoader\Managed\mscorlib.dll
)

if %errorlevel% neq 0 (
	echo [31m
	echo CRITICAL ERROR: Failed to unhollow the assemblies using Il2CppAssemblyUnhollower.
	echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
	echo [0m
	pause
	exit /b %errorlevel%
)
echo Copying output to MelonLoader/Managed
robocopy il2cppassemblyunhollower_output MelonLoader\Managed /XC /XN /XO /NFL /NDL /NJH
if %errorlevel% LSS 0 (
	echo [31m
	echo CRITICAL ERROR: Failed to copy the generated files to the MelonLoader assembly folder ^(robocopy returned %errorlevel%^).
	echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
	echo [0m
	pause
	exit /b %errorlevel%
)
if %errorlevel% GEQ 8 (
	echo [31m
	echo CRITICAL ERROR: Failed to copy the generated files to the MelonLoader assembly folder ^(robocopy returned %errorlevel%^).
	echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
	echo [0m
	pause
	exit /b %errorlevel%
)
set errorlevel=0
echo:

echo [33m-------------------- Final Install ---------------------[0m

if not "%config_postpatch_zip%"=="" (
	if exist "%config_postpatch_zip%" (
		echo Applying final patch %config_postpatch_zip%.
		7z x %config_postpatch_zip% -aoa
	) else (
		echo [33mFile '%config_postpatch_zip%' not found.[0m
	)
) else (
	echo No final patch planned.
)
if %errorlevel% neq 0 (
	echo [33m
	echo WARNING: Failed to apply final patch '%config_postpatch_zip%'.
	echo [0m
)

echo Cleaning up
del 7z.exe
del 7z.dll
rd /S /Q il2cppdumper
::rd /S /Q il2cppdumper_output
rd /S /Q il2cppassemblyunhollower
rd /S /Q il2cppassemblyunhollower_output

IF NOT EXIST Mods mkdir Mods

echo:
echo:
echo [32m
echo ^    --------------------------------------------------
echo ^    ^|         MelonLoader is now installed!          ^|
echo ^    --------------------------------------------------
echo [0m
echo:
echo:

pause

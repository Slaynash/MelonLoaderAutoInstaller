@echo off
CLS

echo:
echo [36m
echo ///
echo ///
echo /// POWERSHELL PROGRESS OUTPUT
echo ///
echo ///
echo [0m
echo ^    --------------------------------------------------
echo ^    ^| MelonLoader AutoInstaller v1.1 by Slaynash     ^|
echo ^    ^|  - MelonLoader v0.1.0                          ^|
echo ^    ^|  - Il2CppDumper v6.2.1                         ^|
echo ^    ^|  - Il2CppAssemblyUnhollower v0.2.0.0           ^|
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
IF EXIST MelonLoader winmm.dll del winmm.dll
echo:

echo Downloading 7zip...
powershell -Command "Invoke-WebRequest https://github.com/Slaynash/MelonLoaderAutoInstaller/raw/master/7z.exe -OutFile 7z.exe"
powershell -Command "Invoke-WebRequest https://github.com/Slaynash/MelonLoaderAutoInstaller/raw/master/7z.dll -OutFile 7z.dll"
echo:

echo [33m----------------- MelonLoader Install ------------------[0m

echo Downloading MelonLoader from github...
powershell -Command "Invoke-WebRequest https://github.com/HerpDerpinstine/MelonLoader/releases/download/v0.1.0/MelonLoader.zip -OutFile melonloader.zip"
if %errorlevel% neq 0 (
	echo [31m
	echo CRITICAL ERROR: Failed to download the MelonLoader zip file.
	echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
	echo [0m
	pause
	exit /b %errorlevel%
)
echo Decompressing MelonLoader...
powershell Expand-Archive melonloader.zip -DestinationPath . -Force
if %errorlevel% neq 0 (
	echo [31m
	echo CRITICAL ERROR: Failed to extract the MelonLoader zip file.
	echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
	echo [0m
	pause
	exit /b %errorlevel%
)
del melonloader.zip
echo:

echo [33m------------------ Il2CppDumper Setup ------------------[0m

echo Downloading Il2CppDumper from github...
powershell -Command "Invoke-WebRequest https://github.com/Perfare/Il2CppDumper/releases/download/v6.2.1/Il2CppDumper-v6.2.1.zip -OutFile il2cppdumper.zip"
if %errorlevel% neq 0 (
	echo [31m
	echo CRITICAL ERROR: Failed to download the Il2CppDumper zip file.
	echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
	echo [0m
	pause
	exit /b %errorlevel%
)
echo Decompressing Il2CppDumper...
powershell Expand-Archive il2cppdumper.zip -DestinationPath il2cppdumper -Force
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

echo Downloading Il2CppAssemblyUnhollower from github...
powershell -Command "Invoke-WebRequest https://github.com/knah/Il2CppAssemblyUnhollower/releases/download/v0.2.0.0/Il2CppAssemblyUnhollower.0.2.0.0.7z -OutFile il2cppassemblyunhallower.zip"
if %errorlevel% neq 0 (
	echo [31m
	echo CRITICAL ERROR: Failed to download the Il2CppAssemblyUnhollower zip file.
	echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
	echo [0m
	pause
	exit /b %errorlevel%
)
echo Decompressing Il2CppAssemblyUnhollower...
7z x il2cppassemblyunhallower.zip -oil2cppassemblyunhallower
if %errorlevel% neq 0 (
	echo [31m
	echo CRITICAL ERROR: Failed to extract the Il2CppAssemblyUnhollower zip file.
	echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
	echo [0m
	pause
	exit /b %errorlevel%
)
del il2cppassemblyunhallower.zip
echo:

echo [33m--------------- Il2CppDumper Generation ----------------[0m

echo Downloading Il2CppDumper config...
powershell -Command "Invoke-WebRequest https://github.com/Slaynash/MelonLoaderAutoInstaller/raw/master/il2cppdumper_config.json -OutFile il2cppdumper/config.json"
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
move DummyDll ..\il2cppdumper_output
cd ..
echo:

echo [33m--------- Il2CppAssemblyUnhollower Generation ----------[0m

mkdir il2cppassemblyunhallower_output

echo Running Il2CppAssemblyUnhollower
il2cppassemblyunhallower\AssemblyUnhollower.exe il2cppdumper_output il2cppassemblyunhallower_output MelonLoader\Managed\mscorlib.dll
if %errorlevel% neq 0 (
	echo [31m
	echo CRITICAL ERROR: Failed to unhollow the assemblies using Il2CppAssemblyUnhollower.
	echo Please report this error to the #melonloader-support channel of the MelonLoader discord ^(https://discord.gg/2Wn3N2P^).
	echo [0m
	pause
	exit /b %errorlevel%
)
echo Copying output to MelonLoader/Managed
robocopy il2cppassemblyunhallower_output MelonLoader\Managed /XC /XN /XO /NFL /NDL /NJH
echo:

echo [33m----------------------- Cleanup ------------------------[0m
del 7z.exe
del 7z.dll
rd /S /Q il2cppdumper
rd /S /Q il2cppdumper_output
rd /S /Q il2cppassemblyunhallower
rd /S /Q il2cppassemblyunhallower_output
echo:
echo:
echo [32mMelonLoader is now installed![0m

pause

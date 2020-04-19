@echo off
CLS
echo:
echo:
echo ///
echo ///
echo ///
echo ///
echo ///
echo:
echo ----------------------------------------------------
echo ^| MelonLoader 0.1.0 AutoInstaller v1.1 by Slaynash ^|
echo ----------------------------------------------------
echo:

echo Cleaning up existing MelonLoader installation
IF EXIST MelonLoader rd /S /Q MelonLoader
IF EXIST MelonLoader winmm.dll del winmm.dll
echo:

echo Downloading 7zip...
powershell -Command "Invoke-WebRequest https://github.com/Slaynash/MelonLoaderAutoInstaller/raw/master/7z.exe -OutFile 7z.exe"
powershell -Command "Invoke-WebRequest https://github.com/Slaynash/MelonLoaderAutoInstaller/raw/master/7z.dll -OutFile 7z.dll"
echo:

echo Downloading MelonLoader from github...
powershell -Command "Invoke-WebRequest https://github.com/HerpDerpinstine/MelonLoader/releases/download/v0.1.0/MelonLoader.zip -OutFile melonloader.zip"
echo Decompressing MelonLoader...
powershell Expand-Archive melonloader.zip -DestinationPath . -Force
del melonloader.zip
echo:

echo Downloading Il2CppDumper from github...
powershell -Command "Invoke-WebRequest https://github.com/Perfare/Il2CppDumper/releases/download/v6.2.1/Il2CppDumper-v6.2.1.zip -OutFile il2cppdumper.zip"
echo Decompressing Il2CppDumper...
powershell Expand-Archive il2cppdumper.zip -DestinationPath il2cppdumper -Force
del il2cppdumper.zip
echo:

echo Downloading Il2CppAssemblyUnhollower from github...
powershell -Command "Invoke-WebRequest https://github.com/knah/Il2CppAssemblyUnhollower/releases/download/v0.2.0.0/Il2CppAssemblyUnhollower.0.2.0.0.7z -OutFile il2cppassemblyunhallower.zip"
echo Decompressing Il2CppAssemblyUnhollower...
7z x il2cppassemblyunhallower.zip -oil2cppassemblyunhallower
del il2cppassemblyunhallower.zip
echo:

for /f %%i in ('dir /b *_Data') do set data_folder=%%i

echo Downloading Il2CppDumper config...
powershell -Command "Invoke-WebRequest https://github.com/Slaynash/MelonLoaderAutoInstaller/raw/master/il2cppdumper_config.json -OutFile il2cppdumper/config.json"
echo:

echo Running Il2CppDumper
cd il2cppdumper
Il2CppDumper.exe ..\GameAssembly.dll ..\%data_folder%\il2cpp_data\Metadata\global-metadata.dat
move DummyDll ..\il2cppdumper_output
cd ..
echo:

mkdir il2cppassemblyunhallower_output

echo Running Il2CppAssemblyUnhollower
il2cppassemblyunhallower\AssemblyUnhollower.exe il2cppdumper_output il2cppassemblyunhallower_output MelonLoader\Managed\mscorlib.dll
echo Copying output to MelonLoader/Managed
robocopy il2cppassemblyunhallower_output MelonLoader\Managed /XC /XN /XO /NFL /NDL /NJH
echo:

echo Cleaning up...
del 7z.exe
del 7z.dll
rd /S /Q il2cppdumper
rd /S /Q il2cppdumper_output
rd /S /Q il2cppassemblyunhallower
rd /S /Q il2cppassemblyunhallower_output
echo:

pause

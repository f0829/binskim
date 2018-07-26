@echo off
SETLOCAL
@REM Uncomment this line to update nuget.exe
@REM Doing so can break SLN build (which uses nuget.exe to
@REM create a nuget package for binskim) so must opt-in
@REM %~dp0.nuget\NuGet.exe update -self

set Configuration=%1
set Platform=AnyCPU

if "%Configuration%" EQU "" (
set Configuration=Release
)

@REM Remove existing build data
if exist bld (rd /s /q bld)

SET NuGetConfigFile=%~dp0src\NuGet.config
set NuGetPackageDir=%~dp0src\packages
set NuGetOutputDirectory=%~dp0bld\bin\nuget\

call WriteVersionConstants.cmd

call Build.cmd || goto :ExitFailed

:: call Test.cmd || goto :ExitFailed

::Create the BinSkim platform specific publish packages
call CreatePublishPackages.cmd || goto :ExitFailed

::Build NuGet package
echo BuildPackages.cmd
call BuildPackages.cmd || goto :ExitFailed

::Create layout directory of assemblies that need to be signed
echo CreateLayoutDirectory.cmd %~dp0bld\bin %Configuration% %Platform%
call CreateLayoutDirectory.cmd %~dp0bld\bin %Configuration% %Platform%

goto :Exit

:ExitFailed
@echo Build and test did not complete successfully.
Exit /B 1

:Exit
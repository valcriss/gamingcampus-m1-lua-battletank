if exist build rd /s /q build
md build
xcopy /E /I assets build\assets
xcopy /E /I framework build\framework
xcopy /E /I libs build\libs
xcopy /E /I models build\models
xcopy /E /I scenes build\scenes
copy main.lua build\main.lua
cd build
tar -a -cf battle-tank.zip *.*
ren battle-tank.zip battle-tank.love
rd /s /q assets
rd /s /q framework
rd /s /q libs
rd /s /q models
rd /s /q scenes
del main.lua
copy ..\redistributable\*.* .\
copy /b love.exe+battle-tank.love battle-tank.exe
del battle-tank.love
del love.exe
tar -a -cf battle-tank.zip *.*
for /R %%i in (*) do if not %%~xi==.zip del "%%i"
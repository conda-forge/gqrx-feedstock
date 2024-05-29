setlocal EnableDelayedExpansion
@echo on

if not exist "%PREFIX%\Menu" mkdir "%PREFIX%\Menu"
copy "%RECIPE_DIR%\gqrx_menu.json" "%PREFIX%\Menu\gqrx.json"
copy "resources\icons\gqrx.ico" "%PREFIX%\Menu"

:: Make a build folder and change to it
mkdir build
cd build

:: configure
:: enable components explicitly so we get build error when unsatisfied
cmake -G "Ninja" ^
    -DCMAKE_BUILD_TYPE:STRING=Release ^
    -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_PREFIX_PATH:PATH="%LIBRARY_PREFIX%" ^
    ..
if errorlevel 1 exit 1

:: build
cmake --build . --config Release -- -j%CPU_COUNT%
if errorlevel 1 exit 1

:: install
cmake --build . --config Release --target install
if errorlevel 1 exit 1

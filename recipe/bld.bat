@rem See https://github.com/jyypma/nloptr/blob/master/INSTALL.windows
cp "%RECIPE_DIR%\CMakeLists.txt" .
if errorlevel 1 exit 1
cp "%RECIPE_DIR%\config.cmake.h.in" .
if errorlevel 1 exit 1

mkdir build && cd build

set CMAKE_CONFIG="Release"

cmake -LAH -G"NMake Makefiles"                     ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%"           ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ..
if errorlevel 1 exit 1

cmake --build . --config %CMAKE_CONFIG% --target install
if errorlevel 1 exit 1




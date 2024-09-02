
mkdir build && cd build

set CMAKE_CONFIG="Release"

cmake -LAH -G"NMake Makefiles"                     ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%"           ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%"        ^
  -DPython_FIND_STRATEGY=LOCATION ^
  -DPython_ROOT_DIR="%PREFIX%" ^
  -DINSTALL_PYTHON_DIR="%SP_DIR%" ..
if errorlevel 1 exit 1

cmake --build . --config %CMAKE_CONFIG% --target install
if errorlevel 1 exit 1

copy nlopt.dll test
ctest --output-on-failure --timeout 100
if errorlevel 1 exit 1

set DIST_INFO_PATH=%SP_DIR%\%PKG_NAME%-%PKG_VERSION%.dist-info
mkdir %DIST_INFO_PATH%
@echo off

(
  echo Metadata-Version: 1.0
  echo Name: %PKG_NAME%
  echo Version: %PKG_VERSION%
) > %DIST_INFO_PATH%\METADATA

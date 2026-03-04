
set CMAKE_CONFIG="Release"

cmake -LAH -G"NMake Makefiles"                     ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%"           ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%"        ^
  -DPython_FIND_STRATEGY=LOCATION ^
  -DPython_ROOT_DIR="%PREFIX%" ^
  -DINSTALL_PYTHON_DIR="%SP_DIR%" ^
  -DNLOPT_GUILE=OFF -DNLOPT_OCTAVE=OFF -DNLOPT_JAVA=OFF -DNLOPT_TESTS=ON ^
  -B build .
if errorlevel 1 exit 1

cmake --build build --config %CMAKE_CONFIG% --target install
if errorlevel 1 exit 1

copy nlopt.dll build\test
ctest --test-dir build -R python --output-on-failure --timeout 100
if errorlevel 1 exit 1


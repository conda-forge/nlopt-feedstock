#!/bin/sh

set -x

if test "${CONDA_BUILD_CROSS_COMPILATION}" == "1"; then
  CMAKE_ARGS="${CMAKE_ARGS} -DPython_NumPy_INCLUDE_DIR=${SP_DIR}/numpy/_core/include"
fi

cmake -LAH ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DPython_FIND_STRATEGY=LOCATION \
  -DPython_ROOT_DIR=${PREFIX} \
  -DNLOPT_GUILE=OFF -DNLOPT_OCTAVE=OFF -DNLOPT_JAVA=OFF -DNLOPT_TESTS=ON \
  -B build .

cmake --build build --target install --parallel ${CPU_COUNT}

if test "$CONDA_BUILD_CROSS_COMPILATION" != "1"
then
  ctest --test-dir build -R python --output-on-failure --schedule-random -j${CPU_COUNT}
fi

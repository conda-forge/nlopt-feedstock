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
  -DNLOPT_GUILE=OFF -DNLOPT_OCTAVE=OFF -DNLOPT_JAVA=OFF \
  -B build .

cd build
make install -j${CPU_COUNT}

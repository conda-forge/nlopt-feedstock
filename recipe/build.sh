#!/bin/sh

set -x

cmake -LAH ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DPython_FIND_STRATEGY=LOCATION \
  -DPython_ROOT_DIR=${PREFIX} \
  -DNLOPT_GUILE=OFF -DNLOPT_OCTAVE=OFF \
  -B build .

cd build
make install -j${CPU_COUNT}

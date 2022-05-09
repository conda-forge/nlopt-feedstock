#!/bin/sh

set -x

if test -f "${PREFIX}/bin/pypy"
then
  PYPY_ARGS="-DPYTHON_INCLUDE_DIR=${PREFIX}/include/pypy${CONDA_PY:0:1}.${CONDA_PY:1} -DPYTHON_LIBRARY=${PREFIX}/lib/libpypy${CONDA_PY:0:1}.${CONDA_PY:1}-c${SHLIB_EXT}"
fi

mkdir build && cd build
cmake ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DNLOPT_GUILE=OFF -DNLOPT_MATLAB=OFF -DNLOPT_OCTAVE=OFF ${PYPY_ARGS} ..

make install -j${CPU_COUNT}

if test -f "${PREFIX}/bin/pypy"
then
  mv ${PREFIX}/lib/python${CONDA_PY:0:1}.${CONDA_PY:1} ${PREFIX}/lib/pypy${CONDA_PY:0:1}.${CONDA_PY:1}
fi

DIST_INFO_PATH=${SP_DIR}/${PKG_NAME}-${PKG_VERSION}.dist-info
mkdir $DIST_INFO_PATH
touch $DIST_INFO_PATH/METADATA

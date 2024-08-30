#!/bin/sh

set -x

if test -f "${PREFIX}/bin/pypy"
then
  PYPY_ARGS="-DPYTHON_INCLUDE_DIR=${PREFIX}/include/pypy${CONDA_PY:0:1}.${CONDA_PY:1} -DPYTHON_LIBRARY=${PREFIX}/lib/libpypy${CONDA_PY:0:1}.${CONDA_PY:1}-c${SHLIB_EXT}"
fi

if test "$CONDA_BUILD_CROSS_COMPILATION" = "1"
then
  target_arch=`echo ${HOST} | cut -f 1 -d "-"`
  test -f "${PREFIX}/bin/pypy" && target_arch=`echo ${target_arch} | sed "s|powerpc64le|ppc_64|g"`
  mod_ext=`python -c "import importlib.machinery; print(importlib.machinery.EXTENSION_SUFFIXES[0])" | sed "s|x86_64|${target_arch}|g"`
  CROSS_ARGS="-DPYTHON_EXTENSION_MODULE_SUFFIX=${mod_ext}"
  if ! test -f "${PREFIX}/bin/pypy"
  then
    CROSS_ARGS="${CROSS_ARGS} -DPYTHON_EXECUTABLE=${BUILD_PREFIX}/bin/python -DPYTHON_LIBRARY=${BUILD_PREFIX}/lib/libpython${CONDA_PY:0:1}.${CONDA_PY:1}${SHLIB_EXT} -DPYTHON_INCLUDE_DIR=${BUILD_PREFIX}/include/python${CONDA_PY:0:1}.${CONDA_PY:1}"
  fi
fi

mkdir build && cd build
cmake -LAH ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DNLOPT_GUILE=OFF -DNLOPT_MATLAB=OFF -DNLOPT_OCTAVE=OFF \
  ${PYPY_ARGS} ${CROSS_ARGS} ..

make install -j${CPU_COUNT}

DIST_INFO_PATH=${SP_DIR}/${PKG_NAME}-${PKG_VERSION}.dist-info
mkdir -p $DIST_INFO_PATH
(
  echo "Metadata-Version: 1.0"
  echo "Name: ${PKG_NAME}"
  echo "Version: ${PKG_VERSION}"
) > $DIST_INFO_PATH/METADATA

#!/bin/sh

set -x

if test -f "${PREFIX}/bin/pypy"
then
  PYPY_ARGS="-DPYTHON_INCLUDE_DIR=${PREFIX}/include/pypy${CONDA_PY:0:1}.${CONDA_PY:1} -DPYTHON_LIBRARY=${PREFIX}/lib/libpypy${CONDA_PY:0:1}.${CONDA_PY:1}-c${SHLIB_EXT}"
  #-DINSTALL_PYTHON_DIR=lib/pypy${CONDA_PY:0:1}.${CONDA_PY:1}/site-packages
fi

mkdir build && cd build
cmake ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DNLOPT_GUILE=OFF -DNLOPT_MATLAB=OFF -DNLOPT_OCTAVE=OFF ${PYPY_ARGS} ..

make install -j${CPU_COUNT}

ext_path=

#if test -f "${PREFIX}/bin/pypy"
#then
#  ARCH=`uname -m`
#  EXT=`${PREFIX}/bin/pypy -c "import importlib.machinery; print(importlib.machinery.EXTENSION_SUFFIXES[0])" | sed "s|x86_64|${ARCH}|g"`
#  mv ${PREFIX}/lib/pypy${CONDA_PY:0:1}.${CONDA_PY:1}/site-packages/_nlopt.so ${PREFIX}/lib/pypy${CONDA_PY:0:1}.${CONDA_PY:1}/site-packages/_nlopt${EXT}
#fi

if test "$CONDA_BUILD_CROSS_COMPILATION" = "1"
then
  ext_path=`python -c "import sysconfig, os; print(sysconfig.get_path('platlib').replace(sysconfig.get_path('data'), '').lstrip(os.path.sep))"`
  ext=`${PREFIX}/bin/pypy -c "import importlib.machinery; print(importlib.machinery.EXTENSION_SUFFIXES[0])"`
  echo "cdt_arch=${cdt_arch}"
fi

DIST_INFO_PATH=${SP_DIR}/${PKG_NAME}-${PKG_VERSION}.dist-info
mkdir -p $DIST_INFO_PATH
touch $DIST_INFO_PATH/METADATA

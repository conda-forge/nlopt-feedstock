#!/bin/sh

set -x

# ninja: error: '../rattler-build_nlopt_1772620307/build_env/x86_64-conda-linux-gnu/sysroot/usr/lib/libm.so'
sed -i.bak "s|\${M_LIBRARY})|m)|g" CMakeLists.txt
cat CMakeLists.txt

if test "${CONDA_BUILD_CROSS_COMPILATION}" == "1"; then
  # https://github.com/conda/conda-build/issues/5563
  if test -d "${SP_DIR}/numpy/_core/include"; then
    CMAKE_ARGS="${CMAKE_ARGS} -DPython_NumPy_INCLUDE_DIR=${SP_DIR}/numpy/_core/include"
  else
    CMAKE_ARGS="${CMAKE_ARGS} -DPython_NumPy_INCLUDE_DIR=$PREFIX/lib/python${PY_VER}t/site-packages/numpy/_core/include"
  fi
fi

cmake -LAH ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DPython_FIND_STRATEGY=LOCATION \
  -DPython_ROOT_DIR=${PREFIX} \
  -DNLOPT_GUILE=OFF -DNLOPT_OCTAVE=OFF -DNLOPT_JAVA=OFF -DNLOPT_TESTS=ON \
  -DM_LIBRARY=m \
  -B build .

cmake --build build --target install --parallel ${CPU_COUNT}

if test "$CONDA_BUILD_CROSS_COMPILATION" != "1"
then
  ctest --test-dir build -R python --output-on-failure --schedule-random -j${CPU_COUNT}
fi

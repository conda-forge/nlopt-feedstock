#!/bin/sh

./configure          \
  --prefix=${PREFIX} \
  --enable-shared    \
  --without-octave   \
  --without-matlab   \
  --without-guile    \
  --with-cxx
make -j${CPU_COUNT}
make install

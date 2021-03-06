#!/bin/bash

mkdir -p prereq
mkdir -p local/lib
mkdir -p local/bin
mkdir -p local/include

ROOT=$(pwd)
cd prereq
if [ ! -f oiio/.git/config ]; then
  git clone git://github.com/OpenImageIO/oiio.git
fi
cd oiio; git pull; cd ..

mkdir -p build/oiio
cd build/oiio

cmake \
  -DCMAKE_INSTALL_PREFIX=${ROOT}/local \
  -DCMAKE_INSTALL_NAME_DIR=@rpath \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
  -DCMAKE_CXX_COMPILER_WORKS=1 \
  -DBUILD_WITH_INSTALL_RPATH=1 \
  -DOPENEXR_CUSTOM_INCLUDE_DIR:STRING=${ROOT}/local/include \
  -DOPENEXR_CUSTOM_LIB_DIR=${ROOT}/local/lib \
  -DBOOST_ROOT=${ROOT}/local \
  -DBOOST_LIBRARYDIR=${ROOT}/local/lib \
  -DBoost_USE_STATIC_LIBS:INT=0 \
  -DBoost_LIBRARY_DIR_RELEASE=${ROOT}/local/lib \
  -DBoost_LIBRARY_DIR_DEBUG=${ROOT}/local/lib \
  -DOCIO_PATH=${ROOT}/local \
  -DPTEX_LOCATION=${ROOT}/local \
  ../../oiio

cmake --build . --target install --config Release

cd ${ROOT}


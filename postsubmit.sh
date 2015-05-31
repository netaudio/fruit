#!/bin/bash

set -e

run_make() {
  make -j2 VERBOSE=1
}

build_codebase() {
  cmake .. -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -DCMAKE_CXX_FLAGS="${CXXFLAGS}"
  run_make
  
  cd examples
  run_make
  cd ..
}

run_tests() {
  cd tests
  run_make
  ctest --output-on-failure -j2
  cd ..
}

mkdir build
cd build

echo "==================================================="
echo "=          Debug mode (compile + test)            ="
echo "==================================================="
export BUILD_TYPE="Debug"
export CXXFLAGS=""
build_codebase
run_tests

echo "==================================================="
echo "=    Release mode with -Werror (compile only)     ="
echo "==================================================="
export BUILD_TYPE="Release"
export CXXFLAGS="-Werror"
build_codebase

echo "==================================================="
echo "=  Release mode without -Werror (compile + test)  ="
echo "==================================================="
export BUILD_TYPE="Release"
export CXXFLAGS=""
build_codebase
run_tests
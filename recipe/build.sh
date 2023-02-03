#!/bin/bash

# conda's gfortran on Linux does not install a binary named 'gfortran'
echo "gfortran = $(which gfortran)"
[[ ! -f "$BUILD_PREFIX/bin/gfortran" && ! -z "$GFORTRAN" ]] && ln -s "$GFORTRAN" "$BUILD_PREFIX/bin/gfortran"
echo "gfortran = $(which gfortran)"

# If doing cross-compiling, hack the shebang for the f2py executable.
if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  shebang="#\!$PREFIX/bin/python"
  f2py_executable=`which f2py`
  sed -i "1s%.*%$shebang%" $f2py_executable
fi

./configure gfortran opt --prefix="$PREFIX" --with-pyoorb
make
make install

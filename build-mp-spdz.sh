#!/bin/bash

cd MP-SPDZ
echo CXX = clang++ >> CONFIG.mine
make -j8 tldr
mkdir static
make -j8 {static/,}{{replicated-ring,hemi}-party,emulate}.x

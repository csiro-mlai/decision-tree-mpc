#!/bin/bash

./prepare.py mixed

out_dir=MP-SPDZ/Player-Data
test -e $out_dir || mkdir $out_dir

cp mixed $out_dir/Input-P0-0

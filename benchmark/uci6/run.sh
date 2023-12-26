#!/bin/bash
set -e

rm -rf RegularizationAndGlobalOptimizationInModelBasedClustering.jl

git clone -b feature/julia185 https://github.com/raphasampaio/RegularizationAndGlobalOptimizationInModelBasedClustering.jl.git

cd RegularizationAndGlobalOptimizationInModelBasedClustering.jl
chmod +x run.sh

./run.sh --algorithm=[1,4,5,6,7,8,9,10,11,12] -i=[6] -k=[] --uci --datasets=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23] --tolerance=0.1 --maxiterations=100

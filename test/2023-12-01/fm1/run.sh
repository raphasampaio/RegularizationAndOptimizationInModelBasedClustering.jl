#!/bin/bash
set -e

rm -rf RegularizationAndGlobalOptimizationInModelBasedClustering.jl

git clone -b feature/julia194 https://github.com/raphasampaio/RegularizationAndGlobalOptimizationInModelBasedClustering.jl.git

cd RegularizationAndGlobalOptimizationInModelBasedClustering.jl
chmod +x run.sh

./run.sh -k=[]

./run.sh --algorithm=[1,4,5,6,7,8,9,10,11,12] -i=[1] -k=[] --uci --datasets=[1] --tolerance=0.01 --maxiterations=100

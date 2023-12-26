#!/bin/bash
set -e

rm -rf RegularizationAndGlobalOptimizationInModelBasedClustering.jl

git clone -b feature/julia185 https://github.com/raphasampaio/RegularizationAndGlobalOptimizationInModelBasedClustering.jl.git

cd RegularizationAndGlobalOptimizationInModelBasedClustering.jl
chmod +x run.sh

./run.sh -i=[5,6]

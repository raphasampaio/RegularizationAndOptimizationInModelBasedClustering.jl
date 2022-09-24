#!/bin/bash
set -e

rm -rf RegularizationAndGlobalOptimizationInModelBasedClustering.jl

git clone https://github.com/raphasampaio/RegularizationAndGlobalOptimizationInModelBasedClustering.jl.git

export JULIA_DOWNLOAD="/tmp/julia/download"
export JULIA_INSTALL="/tmp/julia/install"
export JULIA_DEPOT_PATH="/tmp/julia/.julia"

wget https://raw.githubusercontent.com/abelsiqueira/jill/master/jill.sh
bash jill.sh --no-confirm -v 1.6.7

export PATH=$PATH:"/tmp/julia/install"
export JULIA_167="/tmp/julia/install/julia"

which $JULIA_167
$JULIA_167 --version

cd RegularizationAndGlobalOptimizationInModelBasedClustering.jl
chmod +x run.sh

./run.sh -k=[]

./run.sh -i=[1]  -c=[-0.26] &
./run.sh -i=[2]  -c=[-0.26] &
./run.sh -i=[3]  -c=[-0.26] &
./run.sh -i=[4]  -c=[-0.26] &
./run.sh -i=[5]  -c=[-0.26] &
./run.sh -i=[6]  -c=[-0.26] &
./run.sh -i=[7]  -c=[-0.26] &
./run.sh -i=[8]  -c=[-0.26] &
./run.sh -i=[9]  -c=[-0.26] &
./run.sh -i=[10] -c=[-0.26] &
wait
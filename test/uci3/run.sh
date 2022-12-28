#!/bin/bash
set -e

rm -rf RegularizationAndGlobalOptimizationInModelBasedClustering.jl

git clone https://github.com/raphasampaio/RegularizationAndGlobalOptimizationInModelBasedClustering.jl.git

export JULIA_DOWNLOAD="./julia/download"
export JULIA_INSTALL="./julia/install"
export JULIA_DEPOT_PATH="./julia/.julia"

wget https://raw.githubusercontent.com/abelsiqueira/jill/master/jill.sh
bash jill.sh --no-confirm -v 1.8.4

export PATH=$PATH:"./julia/install"
export JULIA_184="./julia/install/julia"

which $JULIA_184
$JULIA_184 --version

cd RegularizationAndGlobalOptimizationInModelBasedClustering.jl
chmod +x run.sh

./run.sh -k=[]

./run.sh --algorithm=[1,4,5,6,7,8,9,10,11,12] -i=[1]  -k=[] --uci --datasets=[8] &
./run.sh --algorithm=[1,4,5,6,7,8,9,10,11,12] -i=[2]  -k=[] --uci --datasets=[8] &
./run.sh --algorithm=[1,4,5,6,7,8,9,10,11,12] -i=[3]  -k=[] --uci --datasets=[8] &
./run.sh --algorithm=[1,4,5,6,7,8,9,10,11,12] -i=[4]  -k=[] --uci --datasets=[8] &
./run.sh --algorithm=[1,4,5,6,7,8,9,10,11,12] -i=[5]  -k=[] --uci --datasets=[8] &
./run.sh --algorithm=[1,4,5,6,7,8,9,10,11,12] -i=[6]  -k=[] --uci --datasets=[8] &
./run.sh --algorithm=[1,4,5,6,7,8,9,10,11,12] -i=[7]  -k=[] --uci --datasets=[8] &
./run.sh --algorithm=[1,4,5,6,7,8,9,10,11,12] -i=[8]  -k=[] --uci --datasets=[8] &
./run.sh --algorithm=[1,4,5,6,7,8,9,10,11,12] -i=[9]  -k=[] --uci --datasets=[8] &
./run.sh --algorithm=[1,4,5,6,7,8,9,10,11,12] -i=[10] -k=[] --uci --datasets=[8] &
wait
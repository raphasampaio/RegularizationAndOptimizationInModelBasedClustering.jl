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

./run.sh -i=[1]  -k=[] --uci --datasets=[6] &
./run.sh -i=[2]  -k=[] --uci --datasets=[6] &
./run.sh -i=[3]  -k=[] --uci --datasets=[6] &
./run.sh -i=[4]  -k=[] --uci --datasets=[6] &
./run.sh -i=[5]  -k=[] --uci --datasets=[6] &
./run.sh -i=[6]  -k=[] --uci --datasets=[6] &
./run.sh -i=[7]  -k=[] --uci --datasets=[6] &
./run.sh -i=[8]  -k=[] --uci --datasets=[6] &
./run.sh -i=[9]  -k=[] --uci --datasets=[6] &
./run.sh -i=[10] -k=[] --uci --datasets=[6] & # ionosphere
./run.sh -i=[1]  -k=[] --uci --datasets=[7] &
./run.sh -i=[2]  -k=[] --uci --datasets=[7] &
./run.sh -i=[3]  -k=[] --uci --datasets=[7] &
./run.sh -i=[4]  -k=[] --uci --datasets=[7] &
./run.sh -i=[5]  -k=[] --uci --datasets=[7] &
./run.sh -i=[6]  -k=[] --uci --datasets=[7] &
./run.sh -i=[7]  -k=[] --uci --datasets=[7] &
./run.sh -i=[8]  -k=[] --uci --datasets=[7] &
./run.sh -i=[9]  -k=[] --uci --datasets=[7] &
./run.sh -i=[10] -k=[] --uci --datasets=[7] & # iris
./run.sh -i=[1]  -k=[] --uci --datasets=[12] &
./run.sh -i=[2]  -k=[] --uci --datasets=[12] &
./run.sh -i=[3]  -k=[] --uci --datasets=[12] &
./run.sh -i=[4]  -k=[] --uci --datasets=[12] &
./run.sh -i=[5]  -k=[] --uci --datasets=[12] &
./run.sh -i=[6]  -k=[] --uci --datasets=[12] &
./run.sh -i=[7]  -k=[] --uci --datasets=[12] &
./run.sh -i=[8]  -k=[] --uci --datasets=[12] &
./run.sh -i=[9]  -k=[] --uci --datasets=[12] &
./run.sh -i=[10] -k=[] --uci --datasets=[12] & # seeds
./run.sh -i=[1]  -k=[] --uci --datasets=[13] &
./run.sh -i=[2]  -k=[] --uci --datasets=[13] &
./run.sh -i=[3]  -k=[] --uci --datasets=[13] &
./run.sh -i=[4]  -k=[] --uci --datasets=[13] &
./run.sh -i=[5]  -k=[] --uci --datasets=[13] &
./run.sh -i=[6]  -k=[] --uci --datasets=[13] &
./run.sh -i=[7]  -k=[] --uci --datasets=[13] &
./run.sh -i=[8]  -k=[] --uci --datasets=[13] &
./run.sh -i=[9]  -k=[] --uci --datasets=[13] &
./run.sh -i=[10] -k=[] --uci --datasets=[13] & # spect
./run.sh -i=[1]  -k=[] --uci --datasets=[15] &
./run.sh -i=[2]  -k=[] --uci --datasets=[15] &
./run.sh -i=[3]  -k=[] --uci --datasets=[15] &
./run.sh -i=[4]  -k=[] --uci --datasets=[15] &
./run.sh -i=[5]  -k=[] --uci --datasets=[15] &
./run.sh -i=[6]  -k=[] --uci --datasets=[15] &
./run.sh -i=[7]  -k=[] --uci --datasets=[15] &
./run.sh -i=[8]  -k=[] --uci --datasets=[15] &
./run.sh -i=[9]  -k=[] --uci --datasets=[15] &
./run.sh -i=[10] -k=[] --uci --datasets=[15] & # wholesale
./run.sh -i=[1]  -k=[] --uci --datasets=[16] &
./run.sh -i=[2]  -k=[] --uci --datasets=[16] &
./run.sh -i=[3]  -k=[] --uci --datasets=[16] &
./run.sh -i=[4]  -k=[] --uci --datasets=[16] &
./run.sh -i=[5]  -k=[] --uci --datasets=[16] &
./run.sh -i=[6]  -k=[] --uci --datasets=[16] &
./run.sh -i=[7]  -k=[] --uci --datasets=[16] &
./run.sh -i=[8]  -k=[] --uci --datasets=[16] &
./run.sh -i=[9]  -k=[] --uci --datasets=[16] &
./run.sh -i=[10] -k=[] --uci --datasets=[16] & # wines
wait

./run.sh -i=[1]  -k=[] --uci --datasets=[1] &
./run.sh -i=[2]  -k=[] --uci --datasets=[1] &
./run.sh -i=[3]  -k=[] --uci --datasets=[1] &
./run.sh -i=[4]  -k=[] --uci --datasets=[1] &
./run.sh -i=[5]  -k=[] --uci --datasets=[1] &
./run.sh -i=[6]  -k=[] --uci --datasets=[1] &
./run.sh -i=[7]  -k=[] --uci --datasets=[1] &
./run.sh -i=[8]  -k=[] --uci --datasets=[1] &
./run.sh -i=[9]  -k=[] --uci --datasets=[1] &
./run.sh -i=[10] -k=[] --uci --datasets=[1] & # facebook_live_sellers
./run.sh -i=[1]  -k=[] --uci --datasets=[2] &
./run.sh -i=[2]  -k=[] --uci --datasets=[2] &
./run.sh -i=[3]  -k=[] --uci --datasets=[2] &
./run.sh -i=[4]  -k=[] --uci --datasets=[2] &
./run.sh -i=[5]  -k=[] --uci --datasets=[2] &
./run.sh -i=[6]  -k=[] --uci --datasets=[2] &
./run.sh -i=[7]  -k=[] --uci --datasets=[2] &
./run.sh -i=[8]  -k=[] --uci --datasets=[2] &
./run.sh -i=[9]  -k=[] --uci --datasets=[2] &
./run.sh -i=[10] -k=[] --uci --datasets=[2] & # digits
./run.sh -i=[1]  -k=[] --uci --datasets=[3] &
./run.sh -i=[2]  -k=[] --uci --datasets=[3] &
./run.sh -i=[3]  -k=[] --uci --datasets=[3] &
./run.sh -i=[4]  -k=[] --uci --datasets=[3] &
./run.sh -i=[5]  -k=[] --uci --datasets=[3] &
./run.sh -i=[6]  -k=[] --uci --datasets=[3] &
./run.sh -i=[7]  -k=[] --uci --datasets=[3] &
./run.sh -i=[8]  -k=[] --uci --datasets=[3] &
./run.sh -i=[9]  -k=[] --uci --datasets=[3] &
./run.sh -i=[10] -k=[] --uci --datasets=[3] & # hcv
./run.sh -i=[1]  -k=[] --uci --datasets=[4] &
./run.sh -i=[2]  -k=[] --uci --datasets=[4] &
./run.sh -i=[3]  -k=[] --uci --datasets=[4] &
./run.sh -i=[4]  -k=[] --uci --datasets=[4] &
./run.sh -i=[5]  -k=[] --uci --datasets=[4] &
./run.sh -i=[6]  -k=[] --uci --datasets=[4] &
./run.sh -i=[7]  -k=[] --uci --datasets=[4] &
./run.sh -i=[8]  -k=[] --uci --datasets=[4] &
./run.sh -i=[9]  -k=[] --uci --datasets=[4] &
./run.sh -i=[10] -k=[] --uci --datasets=[4] & # human_activity_recognition
./run.sh -i=[1]  -k=[] --uci --datasets=[5] &
./run.sh -i=[2]  -k=[] --uci --datasets=[5] &
./run.sh -i=[3]  -k=[] --uci --datasets=[5] &
./run.sh -i=[4]  -k=[] --uci --datasets=[5] &
./run.sh -i=[5]  -k=[] --uci --datasets=[5] &
./run.sh -i=[6]  -k=[] --uci --datasets=[5] &
./run.sh -i=[7]  -k=[] --uci --datasets=[5] &
./run.sh -i=[8]  -k=[] --uci --datasets=[5] &
./run.sh -i=[9]  -k=[] --uci --datasets=[5] &
./run.sh -i=[10] -k=[] --uci --datasets=[5] & # image_segmentation
./run.sh -i=[1]  -k=[] --uci --datasets=[8] &
./run.sh -i=[2]  -k=[] --uci --datasets=[8] &
./run.sh -i=[3]  -k=[] --uci --datasets=[8] &
./run.sh -i=[4]  -k=[] --uci --datasets=[8] &
./run.sh -i=[5]  -k=[] --uci --datasets=[8] &
./run.sh -i=[6]  -k=[] --uci --datasets=[8] &
./run.sh -i=[7]  -k=[] --uci --datasets=[8] &
./run.sh -i=[8]  -k=[] --uci --datasets=[8] &
./run.sh -i=[9]  -k=[] --uci --datasets=[8] &
./run.sh -i=[10] -k=[] --uci --datasets=[8] & # letter_recognition
./run.sh -i=[1]  -k=[] --uci --datasets=[9] &
./run.sh -i=[2]  -k=[] --uci --datasets=[9] &
./run.sh -i=[3]  -k=[] --uci --datasets=[9] &
./run.sh -i=[4]  -k=[] --uci --datasets=[9] &
./run.sh -i=[5]  -k=[] --uci --datasets=[9] &
./run.sh -i=[6]  -k=[] --uci --datasets=[9] &
./run.sh -i=[7]  -k=[] --uci --datasets=[9] &
./run.sh -i=[8]  -k=[] --uci --datasets=[9] &
./run.sh -i=[9]  -k=[] --uci --datasets=[9] &
./run.sh -i=[10] -k=[] --uci --datasets=[9] & # magic
./run.sh -i=[1]  -k=[] --uci --datasets=[10] &
./run.sh -i=[2]  -k=[] --uci --datasets=[10] &
./run.sh -i=[3]  -k=[] --uci --datasets=[10] &
./run.sh -i=[4]  -k=[] --uci --datasets=[10] &
./run.sh -i=[5]  -k=[] --uci --datasets=[10] &
./run.sh -i=[6]  -k=[] --uci --datasets=[10] &
./run.sh -i=[7]  -k=[] --uci --datasets=[10] &
./run.sh -i=[8]  -k=[] --uci --datasets=[10] &
./run.sh -i=[9]  -k=[] --uci --datasets=[10] &
./run.sh -i=[10] -k=[] --uci --datasets=[10] & # mice_protein
./run.sh -i=[1]  -k=[] --uci --datasets=[11] &
./run.sh -i=[2]  -k=[] --uci --datasets=[11] &
./run.sh -i=[3]  -k=[] --uci --datasets=[11] &
./run.sh -i=[4]  -k=[] --uci --datasets=[11] &
./run.sh -i=[5]  -k=[] --uci --datasets=[11] &
./run.sh -i=[6]  -k=[] --uci --datasets=[11] &
./run.sh -i=[7]  -k=[] --uci --datasets=[11] &
./run.sh -i=[8]  -k=[] --uci --datasets=[11] &
./run.sh -i=[9]  -k=[] --uci --datasets=[11] &
./run.sh -i=[10] -k=[] --uci --datasets=[11] & # pendigits
./run.sh -i=[1]  -k=[] --uci --datasets=[14] &
./run.sh -i=[2]  -k=[] --uci --datasets=[14] &
./run.sh -i=[3]  -k=[] --uci --datasets=[14] &
./run.sh -i=[4]  -k=[] --uci --datasets=[14] &
./run.sh -i=[5]  -k=[] --uci --datasets=[14] &
./run.sh -i=[6]  -k=[] --uci --datasets=[14] &
./run.sh -i=[7]  -k=[] --uci --datasets=[14] &
./run.sh -i=[8]  -k=[] --uci --datasets=[14] &
./run.sh -i=[9]  -k=[] --uci --datasets=[14] &
./run.sh -i=[10] -k=[] --uci --datasets=[14] & # shuttle
./run.sh -i=[1]  -k=[] --uci --datasets=[17] &
./run.sh -i=[2]  -k=[] --uci --datasets=[17] &
./run.sh -i=[3]  -k=[] --uci --datasets=[17] &
./run.sh -i=[4]  -k=[] --uci --datasets=[17] &
./run.sh -i=[5]  -k=[] --uci --datasets=[17] &
./run.sh -i=[6]  -k=[] --uci --datasets=[17] &
./run.sh -i=[7]  -k=[] --uci --datasets=[17] &
./run.sh -i=[8]  -k=[] --uci --datasets=[17] &
./run.sh -i=[9]  -k=[] --uci --datasets=[17] &
./run.sh -i=[10] -k=[] --uci --datasets=[17] & # yeast
wait
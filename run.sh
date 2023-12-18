#!/bin/bash

BASE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

wget https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.4-linux-x86_64.tar.gz
tar -xvzf julia-1.9.4-linux-x86_64.tar.gz

export JULIA_DEPOT_PATH="./julia-env"
./julia-1.9.4/bin/julia --color=yes --project=$BASE_PATH $BASE_PATH/main.jl $@

$JULIA_194 --color=yes --project=$BASE_PATH $BASE_PATH/main.jl $@
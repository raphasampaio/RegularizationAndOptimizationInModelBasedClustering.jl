#!/bin/bash

BASE_PATH ="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
unset XPRESSDIR
unset XPAUTH_PATH
export XPRESS_JL_NO_DEPS_ERROR=1
export XPRESS_JL_NO_AUTO_INIT=1
export XPRESS_JL_SKIP_LIB_CHECK=1

julia --color=yes --project=$BASE_PATH $BASE_PATH/main.jl $@
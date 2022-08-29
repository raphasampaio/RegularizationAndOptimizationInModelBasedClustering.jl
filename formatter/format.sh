#!/bin/bash

FORMATTER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$JULIA_167 --project=$FORMATTER_DIR $FORMATTER_DIR/format.jl
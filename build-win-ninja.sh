#!/bin/bash

# path setup
SCRIPT=$(readlink -f $0)
WD=`dirname $SCRIPT`

# call build.sh
"${WD}"/build.sh -p win-ninja
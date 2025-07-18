#!/bin/bash

set -e # Exit on error

SCRIPT_PATH="`dirname \"$0\"`"

NUMCPUS=`nproc`

TEST_PATH=" \
   $SCRIPT_PATH/../examples/*.py \
   $SCRIPT_PATH/../lvgl/examples/ \
   $SCRIPT_PATH/../lvgl/demos/ \
"

EXCLUDE_PATH=" \
   $SCRIPT_PATH/../examples/fb_test.py \
   $SCRIPT_PATH/../examples/uasyncio*.py \
   $SCRIPT_PATH/../examples/generic-st77xx-with-xpt2046.py \
   $SCRIPT_PATH/../lvgl/demos/music/assets/spectrum.py \
"

EXCLUDE_FINDEXP=$(echo $EXCLUDE_PATH | sed "s/^\|[[:space:]]/ -and -not -path /g")

find $TEST_PATH -name "*.py" $EXCLUDE_FINDEXP |\
   parallel --halt-on-error now,fail=1 --max-args=1 --max-procs $NUMCPUS -I {} timeout 5m  $SCRIPT_PATH/../../../ports/unix/build-lvgl/micropython $SCRIPT_PATH/run_test.py {}


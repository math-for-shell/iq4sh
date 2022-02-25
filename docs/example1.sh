#!/bin/sh
# This demo script shows how to use iq/iq+ in other scripts
src=1 . ./iq    # source the main functions
src=1 . ./iq+    # source the extra functions
# edit above paths/names as needed

echo "example1"   # notify the user that this script does something
# show that main functions from iq are working
echo "example add"
add 1.3785 10.252
# show that functions from iq+ are working
echo "example ipow"
ipow -s7 1.1569821 10
echo "example1 done"
# If you want to load something else, then source it in:
# src=1 . ./cool_stuff_for_upstream-1.0
# and show that your really cool function(s) are working
#fast_approx_sin -s37 22.222222222222222222222222

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

# use a function copied from iq_ai.sh
echo "example soft2max"
# soft2max - activation function
# depends on: 'mul' 'add' 'div'
# cheap substitute 10X faster than softmax
# it suppresses the lowest value more than softmax
# soft2max(x) = x_1^2 / (x_1^2 + x_2^2 +...x_n^2 )
soft2max() { case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;; esac
    a=$1 b=$2 c=$3 
    a_sqr=$( mul -s$scale $a x $a )
    b_sqr=$( mul -s$scale $b x $b )
    c_sqr=$( mul -s$scale $c x $c )
    sum_of_squares=$( add $a_sqr + $b_sqr + $c_sqr )
    a_out=$( div -s$scale $a_sqr / $sum_of_squares )
    b_out=$( div -s$scale $b_sqr / $sum_of_squares )
    c_out=$( div -s$scale $c_sqr / $sum_of_squares )
    echo $a_out $b_out $c_out
} ## softmax2

soft2max 3.1416 2.7182 1.618

echo "example1.sh done"

# If you want to load something else, then source it in:
# src=1 . ./cool_stuff_for_upstream-1.0
# and show that your really cool function(s) are working
#fast_approx_sin -s37 22.222222222222222222222222

#!/bin/sh

# This file is part of the IQ4sh precision calculator
# Neural-network activation functions for the iq/iq+ calculator

# Copyright Gilbert Ashley 25 February 2022
# Contact: OldGringo9876@gmx.de  Subject-line: IQ4sh

# iq_ai_funcs version=1.77

# List of functions and derivative functions included here:
# logistic functions: tanh_real, tanh_pade, tanh_d1, tanh_d2, sigmoid_real, sigmoid_tanh, sigmoid_d1, sigmoid_d2
# Other activation functions: softmax, softmax2, softplus, softplus_d1, softsign, softsign_d1, 
# relu, leaky_relu, swish, mish, logish
# Functions with names ending in '_d1' or '_d2' return 1st and 2nd derivatives of their similarly-named functions

# disable shellcheck style notices and un-helpful suggestions
# shellcheck disable=SC2034,SC2086,SC2295,SC2004,SC1090,SC1091

# tanh_real - tanh(x) = (e^2x -1) / (e^2x + 1)
# depends on: 'exp' 'add' 'div'
tanh_real(){ case $1 in -s*) thrprec=${1#-s*} ; shift ;; *) thrprec=$defprec ;;esac
    tanh_x=$1 up_scale=$((thrprec+3))
    case $tanh_x in '-'*) tanh_neg='-' tanh_x=${tanh_x#*-} ;; *) tanh_neg= ;; esac
    tanh_z=$( add $tanh_x $tanh_x )
    case $tanh_z in '-'*) tanh_neg='-' tanh_z=${tanh_z#'-'*} ;; esac
    tanh_z=$( exp -s$thrprec $tanh_neg$tanh_z )
    tanh_a=$( add -s$up_scale $tanh_z - 1 )
    tanh_b=$( add -s$up_scale $tanh_z + 1 )
    r_tanh=$( div -s$thrprec $tanh_a / $tanh_b )
    echo $tanh_neg$r_tanh
} ## tanh_real  # thrprec= x= up_scale= tanh_z= tanh_a= tanh_b=

# tanh 1st derivative - tanh′(x) = 1 − tanh(x)^2
# depends on: 'tanh_real/tan_pade' 'mul' 'add'
tanh_d1() { case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;;esac
    x=$1 
    trim=$scale scale=$((scale+2))
    a=$( tanh_real -s$scale $x ) # tanh
    #a=$( tanh_pade -s$scale $x )   # faster, maybe less accurate
    a2=$( mul -s$scale  $a $a )
    add -s$trim 1 - $a2
} ## tanh_d1

# tanh 2nd derivative - f′′(x)=−2f(x){1−f(x)2
# depends on: 'tanh_/tanh_pade' 'mul' 'add'
tanh_d2() { case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;;esac
    x=$1 
    trim=$scale scale=$((scale+2))
    a=$( tanh_real -s$scale $x ) # tanh
    #a=$( tanh_pade -s$scale $x )   # faster, maybe less accurate
    a2=$( mul -s$scale  $a $a )
    a3=$( add -s$trim 1 - $a2 ) # tanh_d1
    
    a4=$( mul -s$scale -2 $a )
    mul -s$trim  $a3 $a4
} ## tanh_d2

# tanh_pade - Pade's 5/6 approximation of tanh
# depends on: 'mul' 'add' 'div'
# ~4X faster than tanh_real, accurate to ~4-7 places
# domain -4.41 < x < 4.41 
# p(x) = x*(10395+1260*x**2+21*x**4)/(10395+4725*x**2+210*x**4+x**6)
tanh_pade() { case $1 in -s*) thpscale=${1#-s*} ; shift ;; *) thpscale=$defprec ;;esac
    x=$1
    case $x in '-'*) tanh_neg='-' x=${x#*-} ;; *) tanh_neg= ;; esac
    x2=$( mul -s$thpscale $x $x )
    x4=$( mul -s$thpscale $x2 $x2 )
    x6=$( mul -s$thpscale $x4 $x2 )
    # nom
    a=$( mul -s$thpscale 1260 $x2 )
    b=$( mul -s$thpscale 21 $x4 )
    d=$( add 10395 + $a + $b  )
    e=$( mul -s$thpscale $x $d )
    # denom
    f=$( mul -s$thpscale 4725 $x2 )
    g=$( mul -s$thpscale 210 $x4 )
    j=$( add -s$thpscale  10395 + $f + $g + $x6 )
    
    r_tanh=$( div -s$thpscale $e / $j )
    echo $tanh_neg$r_tanh
} ## tanh_pade

# serpentine
# depedns on: 'mul' 'add' 'div'
serp() { case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;;esac
    x=$1
    #y = 2x / (x^2 + 4)
    # input limits at 0.05 < x < 2.0
    x2=$( mul -s$scale $x $x )
    a=$( mul -s$scale $x 2 )
    c=$( add $x2 + 4 )
    d=$( div -s$scale $a / $c )
    echo $d
}

# Newtons' serpentine
# depends on: 'mul' 'add'
serp_newton() { case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;;esac
    x=$1
    #y = 4x/(x2 + 1)
    nom=$( mul $x 4 )
    denom=$( add 1 + "$( mul -s$scale $x $x )" )
    div -s$scale $nom / $denom
}

# Sigmoid logistic function - 
# sigmoid(x) = (1 + exp(−x))^−1 -or- sigmoid (x) = 1 / (1 + e^-x)
# depends on: 'exp' 'add' 'div'
sigmoid_real() { case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;; esac
    in=$1
    a=$( exp -s$scale -${in#*-} )  # 2X faster using 'exp'
    b=$( add 1 + $a )
    div -s$scale 1 / $b 
} ## sigmoid_real

# the sigmoid logistic function -using tanh to avoid pow
# depends on: 'mul' 'tanh_real/tanh_pade' 'add' 'div'
# σ(x) = (tanh(@x/2)+1) / 2
sigmoid_tanh() { case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;; esac
    x=$1 
    x_divided=$( mul -s$scale $x 0.5 )
    tanh_beta=$( tanh_pade -s$scale $x_divided )  # this is faster
    #tanh_beta=$( tanh_real -s$scale $x_divided )
    tanh_beta_plus_1=$( add $tanh_beta + 1 )
    div -s$scale $tanh_beta_plus_1 / 2 $scale
} ## sigmoid_tanh

# sigmoid 1st derivative
# depends on: 'sigmoid_real/sigmoid_tanh' 'add' 'mul'
# sigmoid'@(x) = (@*sig@(x)) * (1 - sig@(x))
sigmoid_d1() {  case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;; esac
    x=$1
    sig_x=$( sigmoid_real -s$scale $x )
    #sig_x=$( sigmoid_tanh -s$scale $x )    # faster
    one_less_sig_x=$( add 1 - $sig_x )
    mul -s$scale $sig_x $one_less_sig_x
} ## sigmoid_d1

# sigmoid 2nd derivative
# depedns on: 'sigmoid_real/sigmoid_tanh' 'add' 'mul'
# sigmoid'@(x) = (@*sig@(x)) * (1 - sig@(x))
sigmoid_d2() { case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;; esac
    x=$1
    sig_x=$( sigmoid_real -s$scale $x)
    #sig_x=$( sigmoid_tanh -s$scale $x )    # faster
    one_less_sig_x=$( add 1 - $sig_x )
    two_t_sig_x=$( mul 2 $sig_x )
    one_less_2t_sig_x=$( add 1 - $two_t_sig_x )
    sigd2=$( mul $sig_x $one_less_sig_x)
    mul -s$scale $sigd2 $one_less_2t_sig_x
} ## sigmoid_d2

# softmax - activation function
# depends on: 'exp' 'add' 'div'
# softmax(x) = e^x_1 / (e^x_1+e^x_2+...e^x_n )
# using exp instead of pow = 3X faster
softmax() { case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;; esac
    a=$1 b=$2 c=$3 
    e_pow_a=$( exp -s$scale $a )
    e_pow_b=$( exp -s$scale $b )
    e_pow_c=$( exp -s$scale $c )
    sum_of_pows=$( add $e_pow_a + $e_pow_b + $e_pow_c )
    a_out=$( div -s$scale $e_pow_a / $sum_of_pows )
    b_out=$( div -s$scale $e_pow_b / $sum_of_pows )
    c_out=$( div -s$scale $e_pow_c / $sum_of_pows )
    echo $a_out $b_out $c_out
} ## softmax

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

# softplus - activation function
# depends on: 'pow' 'add' 'logx'
# highly accurate, but slow
# best to use at: domain -5<x<5 , scale=5-8
# softplus (x) =ln(1+exp(x))
softplus() { case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;; esac
    a=$1
    z=$( exp -s$scale ${a#*-} )
    w=$( add 1 + $z )
    logx -s$scale e $w
} ## softplus

# softplus 1st derivative
# depends on: 'pow' 'add' 'div'
# softplus'(x) = 1 / (1 + e^-x)
softplus_d1() { case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;; esac
    a=$1 
    z=$( exp -s$scale ${a#*-} )
    a2=$( add 1 + $z )
    div -s$scale 1 / $a2
} ## softplus_d1

# softsign - activation function
# depends on: 'div' 'add'
# highly accurate 
# softsign(x) = x/(1+|x|)
softsign(){ case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;; esac
    div -s$scale $1 / "$( add 1 + ${1#*-} )"
} ## softsign

# softsign 1st derivative
# depends on: 'add' 'mul' 'div'
# highly accurate
# softsign'(x) = 1/(1+|x|)^2
softsign_d1() { case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;; esac
    x=$1
    a=$( add -s$scale 1 + ${x#*-} )
    a2=$( mul -s$scale $a $a )
    div -s$scale 1 / $a2
} ##  softsign_d1

# sgn
# depends on: 'cmp3w'
# sgn can't be fooled with '-0' -both relu's can
sgn() {
    case $( cmp3w $1 0 ) in '>') echo 1;; '<') echo -1;; '=') echo 0;; esac
} ## sgn

# relu - activation function
# relu(x) = max(0,x)
relu() {
    case $1 in '-'*) echo 0 ;; *) echo $1 ;; esac
} ## relu

# leaky_relu - activation function
# leaky_relu(x) = max(0.01,x)
leaky_relu() {
    case $1 in '-'*|0) echo 0.01 ;; *) echo $1 ;; esac
} ## leaky_relu

## No calcualtors found to verify these 3 *ish functions
# swish - activation function
# depends on: 'sigmoid_real/sigmoid_tanh' 'mul'
# swish(x) = x * sigmoid(beta x) = x / (1+e^(beta x)
swish() { case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;; esac
    x=$1
    sigmoid_beta=$( sigmoid_real -s$scale $x )
    #sigmoid_beta=$(sigmoid_tanh -s$scale $x )
    mul -s$scale $x x $sigmoid_beta
} ## swish

# logish - activation function
# depends on: 'sigmoid_real/sigmoid_tanh' 'add' 'logx' 'mul'
# or f(x) = ax * ln[1+sigmoid(bx)]  # where a=1 b=10
# logish(x) = x * ln(1 + sigmoid(x))
logish() { case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;; esac
    x=$1
    sigx=$( sigmoid_real -s$scale $x )
    #sigx=$( sigmoid_tanh -s$scale $x )
    plus1=$( add 1 + $sigx )
    lax=$( logx -s$scale n $plus1 )
    mul -s$scale $x x $lax
} # logish

# mish - activation function
# depends on: 'softplus' 'tanh_real/tanh_pade' 'mul'
# extremely slow when used with tanh_real
# mish(x) = x(tanh(softplus(x)))
mish() { case $1 in -s*) scale=${1#-s*} ; shift ;; *) scale=$defprec ;; esac
    x=$1 
    sft=$( softplus -s$scale $x )
    th=$( tanh_real -s$scale $sft )
    #th=$( tanh_pade -s$scale $sft )
    mul -s$scale $x x $th
} ## mish


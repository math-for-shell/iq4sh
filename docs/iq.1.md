% IQ(1) Version 2.0 | IQ Calculator Documentation

NAME
====

**iq** — An arbitrary precision decimal calculator

SYNOPSIS
========

**iq** func_name \[-s?] number1 operator number2

**iq** \[**-h**|**--help**]

DESCRIPTION
===========

**IQ** performs the basic math operations of Addition, Subtraction, Multiplication, Division, Modular division and Integer exponentiation. It can be used as a command-line calculator, 'sourced' into the shell environment, or used within other shell scripts to replace other CLI calculators. It also serves as the basis for **IQ+**, an advanced version which performs more complex math operations.

*iq* is written completely in minimal shell language, so it is usable under a wide variety of popular Linux/Unix shells, like *bash*, *zsh*, *dash*, *ksh* and *busybox-ash*. It neither reads nor writes to any file and calls no external programs. It uses no dangerous shell constructs like 'eval' or re-direction.

Options
-------

-h, --help

    Prints general usage information.

Structure
---------

*iq* consists of shell functions, each of which performs a basic math operation. The functions are intuitively-named and mostly follow the same basic syntax and usage. When run as a CLI program, *iq* validates all inputs, requires an operator, and performs a single calculation. When used from the shell environment or in scripts, no vetting of inputs is done, operators may not be required, and addition/multiplication can be performed on a series of inputs.

Syntax
------
The basic command syntax of *iq* is: Function-name Number1 Operator Number2

Function-name is one of: *add* *mul* *div* *spow* *tsst*

The functions *add*, *mul* and *div* support scaling of the output, with the '-s?' option, which truncates answers to the desired precision. *spow* also allows scaling, but it only applies when the exponent is negative. When used, the scaling option should be the first parameter after Function-name. When calculating a series of inputs with *add* or *mul*, scaling, if requested, is only performed after the last operation. Otherwise they return the full answer without truncating. If specified scale is zero '-s0', integer output is given.

Numbers: Can be integers or decimal numbers and can be of any length

Operators: Use of the operator is recommended. *div* always requires one the operators '/' or '%'. *mul* allows either 'x' or 'X' as the operator -do not use the asterisk '\*'. *spow* uses the carat '^' as operator, do not use the double-asterisk '\*\*'.

Scale: While there are no hard limits on scale/precision for the basic operations, moderation is recommended. Unlike compiled programs, *iq* cannot access the hardware directly. All math is performed in the form of integers, sometimes digit-for-digit, so processing longer numbers takes more time. Using moderate scales where possible will make calculation times shorter. Still, *iq* has no problem handling scales of 30 to 50, when needed.

FUNCTIONS
=========

Items inside square brackets '[]' are optional and permissible Operators are shown in parentheses '()'.

**add** ---- Addition and Subtraction

    Usage:  'add [-s?] num1 (+-) num2'
    Example: 'add 2.340876 + 1827.749048' = 1830.089924
    Example: 'add -s3 2.340876 + 1827.749048' = 1830.089
    Example: 'add -s0 2.340876 + 1827.749048' = 1830

**mul** ---- Multiplication

    Usage: 'mul [-s?] num1 (xX) num2'
    Example: 'mul 2.340876445 x 1827.74904' = 4278.5346751073628
    Example: 'mul -s4 2.340876445 X 1827.74904' = 4278.5346
    Example: 'mul -s0 2.340876445 X 1827.74904' = 4278

**div** ---- Division and Modular Division(mod)

    Usage: 'div [-s?] num1 (/%) num2'
    Example: 'div -s8 3.52 / 1.4' = 2.51428571
    Example(mod): 'div -s8 3.52 % 1.4' = 0.72
    Example: 'div -s0 3.52 / 1.4' = 2

    If no scale is given a default precision(5) is used:
    Example: 'div 3.52 / 1.4' = 2.51428

**spow** ---- Exponentiation (integer-only)

    Usage: 'spow [-s?] base (^) exponent'
    'spow' is an enhancement of the bash/zsh/ksh '**' operator
    'base' and 'exponent' must be integers, positive or negative
    Example: 'spow 3 ^ 65' = 10301051460877537453973547267843

    If 'exponent' is negative, 'spow' applies SigFig scaling:
    Example: 'spow -s8 7 ^ -13' = 0.000000000010321087
    where '-s8' means '8 Significant Figures'

**tsst** ---- Numeric Comparison of decimal numbers

    Usage: 'tsst num1 (operator) num2'
    Operators: -lt -le -eq -ge -gt -ne

    'tsst' is used like the shells' 'test' built-in
    returning a true/false condition of the comparison
    Example: 'tsst 4.22 -lt 6.3 ; echo $?'
    Example: 'tsst 4.22 -lt 6.3 && echo less'

AUTHOR
======

Gilbert Ashley <https://github.com/math-for-shell/iq4sh>

SEE ALSO
========

**iq+(1)**

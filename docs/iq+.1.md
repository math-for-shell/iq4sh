% IQ+(1) Version 2.0 | IQ+ Advanced Calculator Documentation

NAME
====

**iq+** — Extended version of the **IQ** Precision Decimal Calculator

SYNOPSIS
========

**iq+** func_name \[-s?] number1 operator number2

**iq+** \[**-h**|**--help**]

**iq+** func_name \[**-h**]

DESCRIPTION
===========

**IQ+** Extends the basic math functions provided by the **IQ** calculator. It includes functions for more complex operations such as logarithms, roots, powers and trigonometry. It also provides a more flexible way to use the basic functions *add* and *mul* from **iq**.

**iq+** dispenses with the rigorous input checking done by **iq**, so 'garbage-in=garbage-out' rules apply. *USER* can easily learn the simple syntax by calling the general help for **iq**, the help for the basic functions themselves or by using **iq** a few times to learn the syntax.

Options
-------

-h, --help

    Prints general usage information.

Structure
---------

*iq+* consists of shell functions, each of which performs a complex math calculation. The functions are intuitively-named and similar to those of other calcualtors. *iq+* relies on the basic math functions from *iq*, so *iq* must also be available in the same location as *iq+*.  
When run from the CLI, **iq+** automatically 'sources', or includes the basic math functions from **iq**, so they are also available from **iq+**.

Syntax
------

None of the functions in **iq+** require an Operator, but the Carat '^' can be used with 'pow', 'ipow' and epow'  
When called from **iq+**, *add* and *mul* do not require the use of an operator and can perform addition, subtraction or multiplication on a series of numbers.  
*div* still requires an operator '/' or '%' ^(for mod)

FUNCTIONS
=========

**logx** ---- Calculates Logarithms in base 10, 2 or 'e'

    Usage: 'logx [-s?] base num1'
    Example: 'logx -s8 10 6.7' for base10: log(6.7)
    Example: 'logx -s7 n 6.7' for base'e': ln(6.7)
    Example: 'logx -s7 2 6.7' for base2: log2(6.7)

    Accurate to ~11 decimal places

**nroot** ---- Calculates the nth-root of a number

    Usage: 'nroot [-s?] Number Nth'
    Example: 'nroot -s6 4.3 10' for: 10th root of 4.3
    Example: 'nroot -s8 43.225 2' for: sqrt of 43.225
    Example: 'nroot -s11 2 2' = 1.414213562373

    'Number' must be positive, integer or decimal
    'Nth' must be a positive integer

**exp** ---- Raises Euler's number 'e' to a given power (e^x)

    Usage: 'exp [-s?] exponent'
    Example: 'exp -s15 3.6' = 36.598234443677978
    Example: 'exp -s8 1.134' = 3.10806392

   *exp* input range is limited to 'exponent'<19.0

**pow** ---- Raises an integer or decimal number to a given power

    Usage: 'pow [-s?] base [^] exponent'
    Example: 'pow -s9 3.141592 ^ 6' = 961.387993507
    Example: 'pow -s12 12.141592 -6' = 0.000000312137
    Precision is not limited, when 'exponent' is an integer

    Decimal exponents are supported, if 'base' < 4.0
    Example: 'pow -s11 3.14 ^ -4.123558' = 0.00893062336
    Accuracy is ~11 places but increases as 'base' nears zero:
    Example: 'pow -s15 0.618  7.385' = 0.028605522741231

    Use of the Operator '^' is optional

**ipow and epow** ----  Both serve as back-end functions to *pow* but can also be used separately.  
*epow* is particularly useful with very large or small numbers, since it can return answers  
in Scientfic Notation. Both functions work only with a positive 'base' and integer 'exponent'.

**ipow** ---- Raise a positive 'base' to an integer power

    Usage: 'ipow [-s?] base [^] exponent'
    Example: 'ipow -s9  9.35234 16' = 3425504893420641.057301958

**epow** ---- Raise a positive 'base' to an integer power

    Usage: 'epow [-s?,-S,-e?] base [^] exponent'
    'epow' returns powers with answers in three forms: normally-
    scaled outputs, Significant Figures or Scientific (e-)Notation.
    Output format is controlled with 3 scaling options: -s? -S? or -e?

    Example usage for normal scaling: 'epow -s9 0.14 7' = 0.000001054
    Example for significant digits: 'epow -S9 0.14 7' = 0.00000105413504
    Example for scientific notation: 'epow -e9 0.14 7' = 1.05413504e-6
    Example for scientific notation: 'epow -e12 42.818 7' = 2.638667359224e11

**sin** ---- Calculates the sine of an angle

    Usage: 'sin [-s?] angle'
    'angle' can be integer or decimal, in degrees
    Accuracy: ~12 places at any 'angle'
    Example usage: 'sin -s6 91.35' = 0.999767
    Example usage: 'sin -s12 29.4567' = 0.491765667756

**cos** ---- Calculates the cosine of an angle

    Usage: 'cos' usage: 'cos [-s?] angle'
    'angle' can be integer or decimal, in degrees
    Accuracy: ~12 places at any 'angle'
    Example usage: 'cos -s6 28.573' = 0.878208
    Example usage: 'cos -s12 98.827' = -0.153451510933

**tan** ---- Calculates the tangent of an angle

    Usage: 'tan [-s?] angle'
    'angle' can be integer or decimal, in degrees
    Accuracy: 12 places for any 'angle', except near
    90 or 270 degrees, where 'tan' approaches +-infinity
    At 90/270 +-0.1, accuracy is ~11 digits
    At 90/270 +-0.000001, accuracy is only 1 digit
    Example usage: 'tan -s6 28.573' = 0.544606
    Example usage: 'tan -s12 98.827' = -6.439533718717

**dgrs2rdns and rdns2dgrs** ---- Convert degrees to/from radians  
    Utility functions used by *sin* and *cos*  
    Example: 'dgrs2rdns 135.724' = 2.36883  
    Example: 'rdns2dgrs 1.6538' = 94.75576

Utility Functions
-----------------
**factorial** ---- Returns the 'Factorial' of a number  
    Requires 1 integer input  
    Example: 'factorial 5' = 120  
**gcf** ---- Returns the Greatest Common Factor of 2 numbers  
    Requires 2 integer inputs  
    Example: 'gcf 123 396' = 3  
**dec2frac** ---- Converts a Decimal Fraction into a whole-number fraction  
    Requires a decimal fraction input  
    Example: 'dec2frac 0.1388' = 347/2500

AUTHOR
======

Gilbert Ashley <https://github.com/math-for-shell/iq4sh>

SEE ALSO
========

**iq(1)**

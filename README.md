# ULCParser

## Parser for the untyped lambda calculus

This is a simple implementation of a **parser** for the untyped lambda calculus (ULC), seen as a programming language. 
Besides checking the syntactic correctness of a given program, the aim of the parser is to produce a **structured** 
representation of the source code, which will be used for **evaluation** purposes by the [UCLInterpreter](https://github.com/Iulian-Stan/ULCInterpreter).


### Example 

This is the used input:

```
true=\x.\y.x 
false=\x.\y.y 

not=\x.((x false) true)
(not true) 
(not false)

and=\x.\y.((x y) false)
((and true) true)
((and true) false)
((and false) true)
((and false) false)

or=\x.\y.((x true) y)
((or true) true)
((or true) false)
((or false) true)
((or false) false)

nil=\x.true
null=\l.(l \x.\y.false)
cons=\x.\y.\z.((z x) y)
car=\l.(l true)
cdr=\l.(l false)
if=\p.\then.\else.((p then) else)

fix=\f.(\x.(f (x x)) \x.(f (x x)))
(fix fun)

append=\a.\b.((fix \r.\a.(((if (null a)) b) 
                          ((cons (car a)) (r (cdr a))))) a)
la=((cons x) nil)
lb=((cons y) ((cons z) nil))
lc=((append la) lb) 
(car lc)
(car (cdr lc))
(car (cdr (cdr lc)))
```


### Syntax

A **program** is provided as a string, which contains a sequence of expressions and definitions, separated by white space. The language **expressions** are given below, along with their corresponding **syntax**:

* variabiles: ``x``
* functions: ``\x.expr``
* applications: ``(expr1 expr2)``.

For convenience, a program may also contain:

* definitions i.e., top-level variable bindings: ``var=expr``.

The parser implements a **top-level function** such as ``parseProgram``, which receives a **program string** (as above) and returns its structured **internal representation**. 
For instance, the internal representation is as follows:
* ``x`` is ``Var "x"``, where ``Var`` is a user-defined data constructor
* ``\x.(x x)`` is ``Lambda "x" (Application (Var "x") (Var "x"))``, where ``Lambda`` and ``Application`` are also user-defined data constructors.


### Running the aplpication

This is a simple aplpication that can be run using [Hugs 98](https://www.haskell.org/hugs/pages/downloading.htm) 
that provides an almost complete implementation of Haskell 98. Although it is no longer in development it is lightweiht 
and satisfies all the needs for running this application.

After launching **Hugs 98** you should run two commands:
 1. ``:load interpreter.hs``
 2. ``parseProgram "program.in"``

It will display the input program in the described above representation.

# Binary-decision-diagram

Implement binary decision diagram.

The main feature of the project is the BinaryDecisionDiagram module which is able to represent propositional formula from the standard input as compact binary decision diagram and perform various operations on them, such as evaluation.

The achieve that the project is composed of three major component :

+ The parser
+ The decision tree module
+ The binary decision diagram module

The whole module is parametrised by a module that should defin a type following the signature 

``` Ocaml
module type Type = sig
    type t
    val default : t
    val string_to_type : string -> t
    val type_to_string : t -> string
end
```

This type is used to represent variables internally, by default the module StringType is included.

## Features

### propositional formula

In this project propositional formula should use the following symbols :

+ Not : ~
+ And : && (surrounded with blank spaces)
+ Or : || (surrounded with blank spaces)
+ Imply : -> (surrounded with blank spaces)
+ If and only if : <-> (surrounded with blank spaces)
+ True : true
+ False : false
+ Any variable : any other unused string without spaces
+ Parenthesis : ( )

for instance, a valid expression could be :
~a && (c || b -> a)

### binary decision diagram

A binary decision diagram is composed of node that point to two other nodes and so on until they reach the node True or the node False. The edges are labeled with True of False.
To evaluate the whole expression one should follow the edges corresponding to the value of the corresponding variables.

For instance, the expression "a && (~b || c)" produce the diagram :

```
0 a 1 @f
1 b 2 @t
2 c @t @f
```

where @t is the label true and @f the label false.
If a = @t, b = @t and c = @f then we can evaluate the expression as follow:

+ We start from the node with id 0 (this is always the entry point), a in this case, its value is true so we follow the first edge with label 1.
+ The node with id 1 is b, its value is true so we follow the first edge again, with label 2.
+ The node with id 2 is c, this time c is false so we follow the second edge, it points toward @f so the expression is evaluated to false.

### the demo module

The file bdd.ml can be compiled to test the features of the BinaryDecisionDiagram module:

```
make
```

this create the bdd executable. To run it use the command 

```
./bdd cmd
```

Where cmd should be one among :

#### dump

Ask for a propositional formula in input and print its binary decision diagram.

#### valid

Ask for a propositional formula in input and exit with status 0 if the formula is valid otherwise exit with status 1.

#### satisfiable

Ask for a propositional formula in input and print a valuation that satisfy the proposition if it is satisfiable.

#### valuation

Ask for a valuation in input, with the format :

```
Variable value
```

With "Variable" the name of the variable and "value" its value ("f" or "@f" for false, anything else for true). Skip a line to validate the input and print the corresponding valuation.

#### eval

Ask for a propositional formula in input and a valuation. Print the evaluation of the formula.

## The Parser

The parser is able to convert input boolean expression seen as string to internal representation under the type Prop.prop

You can test the parser with the commands :

```
make test_parser
./test_parser
```

It takes a propositional formula in input and print the proposition tree.

For instance, the expression "a && b || c" produce proposition tree :
```
 or
|--- and
    |--- a
    |--- b
|--- c
```

which mean that we have an "or" operation between in one hand a && b and in the other hand c.


## Decision Tree

This module is build upon the parser and convert the input propositional formula to another internal representation under the type DecisionTree.t. This representation use a tree in which nodes are variables with two children (one if the variable is true, the other one if not) and leaves are boolean.

This module is able to compress the produced tree in order to feed it to the module BinaryDecisionDiagram.

The module can be tested with the commands :

```
make test_decisionTree
./test_decisionTree
```

Which print the decision tree and the compressed decision tree that correspond to the input formula.

For instance :

```
Input proposition :
a && b
Full decision tree :

 a
|--- b
    |--- False
    |--- False
|--- b
    |--- False
    |--- True

Compressed decision tree :

 a
|--- False
|--- b
    |--- False
    |--- True

```

"a" is the root, the first variable to be evaluated, the first branch should be evaluated if "a" is false, the second one if "a" is true. In the compressed tree, we see that if "a" is false, the proposition is also false and there is no need to evaluate b.

## Binary Decision Diagram

The core module of the project which is build upon decision tree and feature a new type to implement an efficient representation of propositional formula.

Unlike compressed decision tree in which the same subtree can appear more than once, binary decision diagrams maximize the sharing between subtrees and there is a guarantee that there is no redundancy.

The module implement the following signature :

```OCaml
module type Bdd = functor (T : Type) ->
sig
    type bdd
    type valuation

    val print_bdd : bdd -> unit
    val read_bdd : unit -> bdd
    val evaluate : bdd -> valuation -> bool
    val is_valid : bdd -> bool
    val satisfiable : bdd -> valuation
    val read_valuation : unit -> valuation
    val print_valuation : valuation -> unit
end
```

And can be tested through the bdd.ml file as explained above.
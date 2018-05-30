# Binary-decision-diagram

Implement binary desicion diagram.

The main feature of the project is the BinaryDecisionDiagram module which is able to represent propositional formula from the standard input as compact binary decision diagram and perform various operations on them, such as evaluation.

The achieve that the project is composed of three major component :

+ The parser
+ The decision tree module
+ The binary decision diagram module

## Features

### propositional formula

In this project propositional formula should use the following symbols :

+ Not : ~
+ And : && (surrounded with blank spaces)
+ Or : || (surrounded with blank spaces)
+ Imply : -> (surrounded with blank spaces)
+ If and only if : <-> (surrounder with blank spaces)
+ True : true
+ False : false
+ Any variable : any other unused string without spaces
+ Parenthesis : ( )

for instance, a valid expression could be :
~a && (c || b -> a)

### dinary decision diagram

A binary decision diagram is composed of node that point to two other nodes, until they reach the node True or the node False. The edges are labeled with True of False.
To evaluate the corresponding expression one should follow the edges corresponding to the value of the corresponding variables.

For instance, the expression "a && (~b || c)" produce the diagram :

```
0 a 1 @f
1 b 2 @t
2 c @t @f
```

where @t is the label true and @f the label false.
If a = @t, b = @t and c = @f then we can evaluate the expression as follow:

+ We start from the node with id 0, a in this case, its value is true so we follow the first edge with label 1.
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

#### tree

Ask for a propositionnal formula in input and print a representation as a full decision tree, a simplyfied decision tree and the binary decision diagram.

For instance, the expression a && b produce the full tree :
```
 a
|--- b
    |--- False
    |--- False
|--- b
    |--- False
    |--- True
```
The first edge is always labeled False and the second True.

#### dump

Ask for a propositionnal formula in input and print its binary decision diagram.

#### valid

Ask for a propositionnal formula in input and exit with statut 0 if the formula is valid otherwise exit with statut 1.

#### satisfiable

Ask for a propositionnal formula in input and print a valuation that thatisfy the proposition if it is satisfiable.

#### valuation

Ask for a valuation in input, with the format :

Variable value

with Variable the name of the variable and value its value (f or @f for false, anything else for true). Skip a line to validate the input and print the corresponding valuation.

#### eval

Ask for a propositionnal formula in input and the a valuation. Print the evaluation of the formula.

## The Parser

The parser is able to convert boolean expression to internal representation under the type Prop.prop

You can test the parser with the commands :

```
make test_parser
./test_parser
```

It takes a propositionnal formula in input and print the proposition tree.

## Decision Tree

This module is build upon the parser and allow to convert the input propositional formula of type DecisionTree.t.

The module is able to compress the produced tree in order to feed it to the module BinaryDecisionDiagram.

You can test the module with the commands :

```
make test_decisionTree
./test_decisionTree
```

Which print the decision tree and the compressed decision tree that correspond to the input formula.

## Binary Decision Diagram

The core module of the project which is build upon decision tree and feature a new type to implement an efficient representation of propositionnal formula.

You can test it with the bdd.ml file, as explained above.
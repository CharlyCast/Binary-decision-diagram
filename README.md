# Binary-decision-diagram

Implement binary desicion diagram

## Proposition

The parser is able to convert boolean expression to internal representation under the type Prop.prop

You can test the parser with the commands : 

- - -

make test_prop

./test_prop

- - -

Acceptable symbols are :

+ True : true
+ False : false
+ Not : ~_
+ And : _ && _
+ Or : _ || _
+ Imply : _ -> _
+ If and only if : _ <-> _
+ Variable : any_other_string_without_space
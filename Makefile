# Main file
bdd: type.cmo prop.cmo parser.cmo decisionTree.cmo binaryDecisionDiagram.cmo bdd.cmo
	ocamlc type.cmo prop.cmo parser.cmo decisionTree.cmo binaryDecisionDiagram.cmo bdd.cmo -o bdd

bdd.cmo: type.cmo prop.cmo parser.cmo decisionTree.cmo binaryDecisionDiagram.cmo bdd.ml
	ocamlc type.cmo prop.cmo parser.cmo decisionTree.cmo binaryDecisionDiagram.cmo bdd.ml -c

# Test files
# Decision tree test
test_decisionTree: type.cmo parser.cmo prop.cmo decisionTree.cmo binaryDecisionDiagram.cmo test_decisionTree.cmo 
	ocamlc type.cmo prop.cmo parser.cmo decisionTree.cmo binaryDecisionDiagram.cmo test_decisionTree.cmo -o test_decisionTree

test_decisionTree.cmo: type.cmo parser.cmo prop.cmo decisionTree.cmo binaryDecisionDiagram.cmo test_decisionTree.ml
	ocamlc type.cmo prop.cmo parser.cmo decisionTree.cmo binaryDecisionDiagram.cmo test_decisionTree.ml -c

# Evaluation test
test_eval: type.cmo parser.cmo prop.cmo test_eval.cmo
	ocamlc type.cmo prop.cmo parser.cmo test_eval.cmo -o test_eval

test_eval.cmo: type.cmo parser.cmo prop.cmo test_eval.ml
	ocamlc type.cmo prop.cmo parser.cmo test_eval.ml -c

#Parser test
test_parser: type.cmo parser.cmo prop.cmo test_parser.cmo
	ocamlc type.cmo prop.cmo parser.cmo test_parser.cmo -o test_parser

test_parser.cmo: type.cmo parser.cmo prop.cmo test_parser.ml
	ocamlc type.cmo prop.cmo parser.cmo test_parser.ml -c

# Dependencies
binaryDecisionDiagram:  type.cmo prop.cmo parser.cmo decisionTree.cmo binaryDecisionDiagram.cmo
	ocamlc -o binaryDecisionDiagram type.cmo prop.cmo parser.cmo decisionTree.cmo binaryDecisionDiagram.ml

binaryDecisionDiagram.cmo: type.cmo prop.cmo parser.cmo decisionTree.cmo binaryDecisionDiagram.ml
	ocamlc -c type.cmo prop.cmo parser.cmo decisionTree.cmo binaryDecisionDiagram.ml

decisionTree: type.cmo parser.cmo prop.cmo decisionTree.cmo
	ocamlc type.cmo prop.cmo parser.cmo decisionTree.cmo

decisionTree.cmo: type.cmo parser.cmo prop.cmo decisionTree.ml
	ocamlc type.cmo prop.cmo parser.cmo decisionTree.ml -c

parser: type.cmo parser.cmo prop.cmo
	ocamlc type.cmo prop.cmo parser.cmo -o parser

parser.cmo: prop.cmo parser.ml
	ocamlc prop.cmo parser.ml -c

prop.cmo: type.cmo prop.ml
	ocamlc prop.ml -c

type.cmo: type.ml
	ocamlc type.ml -c

# Remove all temporary files
clean:
	rm -f *.cmo
	rm -f *.cmi

# Remove every compiled files, can be used to make a complete rebuild
mrproper: clean
	rm -f bdd
	rm -f test_eval
	rm -f test_parser
	rm -f test_decisionTree
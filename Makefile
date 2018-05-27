# Main file
bdd: bdd.cmo
	ocamlc bdd.cmo -o bdd

bdd.cmo: bdd.ml
	ocamlc bdd.ml -c

# Test files
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
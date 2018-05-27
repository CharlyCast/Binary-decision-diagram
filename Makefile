bdd: bdd.cmo
	ocamlc bdd.cmo -o bdd

bdd.cmo: bdd.ml
	ocamlc bdd.ml -c

test_prop: type.cmo parser.cmo prop.cmo test_prop.cmo
	ocamlc type.cmo prop.cmo parser.cmo test_prop.cmo -o test_prop

test_prop.cmo: type.cmo parser.cmo prop.cmo test_prop.ml
	ocamlc type.cmo prop.cmo parser.cmo test_prop.ml -c

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
bdd: bdd.cmo
	ocamlc bdd.cmo -o bdd

bdd.cmo: bdd.ml
	ocamlc bdd.ml -c

# Remove all temporary files
clean:
	rm -rf *.cmo
	rm -rf *.cmi

# Remove every compiled files, can be used to make a complete rebuild
mrproper: clean
	rm -rf bdd
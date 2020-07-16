main.native:
	ocamlbuild -use-ocamlfind -package core,core_bench,stdint,batteries -tag thread  -tag annot main.native -lflags -O2

main.native: main.ml stubs.c
	ocamlfind ocamlopt -linkpkg -package core,core_bench,stdint,batteries -thread  -annot -O2 main.ml stubs.c -o main.native

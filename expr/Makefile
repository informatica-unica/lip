projects = boolexpr andboolexpr arithexpr sarithexpr

main:
	echo "\n\
	Usage: make <project>\n\n\
	\
	Please specify a project to initialize.\n\
	The options are: $(projects)\n"

.PHONY: $(projects) clean

all: $(projects)

$(projects):
	dune init proj $@ ; \
		cd $@ ; \
		echo '(using menhir 2.1)' >> dune-project ; \
		echo '\n(menhir (modules parser))\n\n(ocamllex lexer)' >> lib/dune ; \
		rm test/test_$@.ml ; \
		echo "\
(library\n\
 (name $@Test)\n\
 (inline_tests)\n\
 (preprocess (pps ppx_inline_test))\n\
 (libraries $@))" > test/dune

clean:
	find . -maxdepth 3 -name "*.opam" -delete -print ; \
	find . -maxdepth 3 -name "dune*" -delete -print

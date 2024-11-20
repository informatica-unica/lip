projects = boolexpr andboolexpr arithexpr sarithexpr

main:
	echo "\nPlease specify a project to initialize.\n\n\
	The options are: $(projects)\n"

.PHONY: $(projects)

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



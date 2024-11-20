projects = blocks fun while

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
		sed -i 's/name $@/name $@Lib/' lib/dune ; \
		sed -i 's/libraries $@/libraries $@Lib/' bin/dune ; \
		echo '(using menhir 2.1)' >> dune-project ; \
		echo '\n(menhir (modules parser))\n\n(ocamllex lexer)' >> lib/dune ; \
		rm test/test_$@.ml ; \
		echo "\
(library\n\
 (name $@Test)\n\
 (inline_tests)\n\
 (preprocess (pps ppx_inline_test))\n\
 (libraries $@Lib))" > test/dune

clean:
	find . -maxdepth 3 -name "*.opam" -delete -print ; \
	find . -maxdepth 3 -name "dune*" -delete -print

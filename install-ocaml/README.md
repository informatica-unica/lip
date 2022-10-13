# Installing OCaml

This file contains minimal instructions to setup a local installation of OCaml un Linux.
See [here](https://ocaml.org/docs/up-and-running) for detailed instructions here.

First, install opam, the OCaml official package manager:
```bash
sudo apt install opam
```
Then, you must initialize opam. This installs OCaml and creates a default switch:
```bash
opam init --bare -a -y
```
Here we assume you will work on the default switch. You can create a dedicated switch for LIP if you prefer.

The following command updates environment variables, to make OCaml commands available on the current switch:
```bash
eval $(opam env)
```

Finally, install a few extra OCaml packages:
```bash
opam install -y dune merlin ocaml-lsp-server odoc ocamlformat utop menhir ppx_inline_test
```
In particular, this installation includes:
- [**dune**](https://dune.readthedocs.io/), a build system for OCaml projects, similar to make;
- [**utop**](https://opam.ocaml.org/blog/about-utop/), a REPL interface for OCaml;
- [**Menhir**](http://gallium.inria.fr/~fpottier/menhir/), a parser generator;
- [**ppx_inline_test**](https://github.com/janestreet/ppx_inline_test), a tool for writing in-line tests in OCaml.

We will use these tools for all the projects of the LIP course.

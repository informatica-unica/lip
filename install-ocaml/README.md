# Setting up OCaml

This file contains minimal instructions to setup a local installation of OCaml on Linux.
See [here](https://ocaml.org/docs/up-and-running) for instructions on other OSs.

## Installing OCaml

First, install opam, the OCaml official package manager:
```bash
sudo apt install opam
```
Then, you must initialize opam. This installs OCaml and creates a default switch:
```bash
opam init --bare -a -y
```
Here we assume you will work on the default switch. To check that a switch actually exists:
```bash
opam switch list
```
In case the previous command shows an empty list, you must manually create a switch:
```bash
opam switch create lip ocaml-base-compiler.4.14.0
```
This creates a switch for the LIP course with the given version of the OCaml compiler.

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

If you plan to use the emacs editor, run:
```bash
opam user-setup install
```

## First project

To check that everything is installed correctly, we set up a first project (see [here](https://ocaml.org/docs/up-and-running#starting-a-new-project) for more detailed instructions).

First, we create a new project called `helloworld` using dune and then change into the created directory. Below, the lines starting with `>` contain the expected output of the given shell commands:
```
dune init project helloworld
> Success: initialized project component named helloworld
cd helloworld
```

To build the project run `dune build` from the `helloworld` directory. If there are no errors, the output should be empty:
```
dune build
```

If the build is successful, we can run the project as follows:
```
dune exec helloworld
> Hello, World!
```

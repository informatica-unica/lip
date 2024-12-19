# Tiny Rust

Initialize the project with:
```
dune init proj tinyrust
```

Build your code and run the tests interactively with:
```
dune test --watch
```
<br>

We encourage you to use the data structures provided by the [OCaml standard library](https://ocaml.org/manual/5.2/api/index.html) wherever you see fit. To name a few: [Stack](https://ocaml.org/manual/5.2/api/Stack.html), [Hashtbl](https://ocaml.org/manual/5.2/api/Hashtbl.html), [Array](https://ocaml.org/manual/5.2/api/Array.html), [Result](https://ocaml.org/manual/5.2/api/Result.html), [Option](https://ocaml.org/manual/5.2/api/Option.html)...

Your project may also depend on external opam libraries. For example, to get nice error messages from the parser, you can use the [nice-parser](https://ocaml.org/p/nice_parser/latest) library.

Lastly, we recommend installing the [ocamlformat](https://github.com/ocaml-ppx/ocamlformat?tab=readme-ov-file#------ocamlformat--) tool:
```
opam install ocamlformat
```
This will automatically format your code whenever you save your source file or hit Ctrl+S, adding indentation and whitespace where appropriate.

## Resources

* [The Rust Reference](https://doc.rust-lang.org/reference/introduction.html?search=)
* [OCaml language guide](https://ocaml.org/docs/values-and-functions). Interesting articles:
  - [Records](https://ocaml.org/docs/basic-data-types#records)
  - [Mutability](https://ocaml.org/docs/mutability-imperative-control-flow)
* [ocamllex manual](https://ocaml.org/manual/5.2/lexyacc.html#)
  - [Regular expression syntax](https://ocaml.org/manual/5.2/lexyacc.html#ss:ocamllex-regexp)
* [Menhir manual](https://cambium.inria.fr/~fpottier/menhir/manual.html)
  - [The standard library](https://cambium.inria.fr/~fpottier/menhir/manual.html#sec38)
* [Setting up Visual Studio Code for OCaml](https://ocaml.org/docs/set-up-editor#visual-studio-code)

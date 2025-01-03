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

## Test files

- [Examples](examples/)
- [Parser tests](test_parser.ml)
- [Trace tests](test_trace.ml)

The tests make some assumption about the interface of your interpreter and where you
put the useful functions. You're free to adapt the tests to work with your implementation, or vice versa.

The tests also depend on the [ppx_expect](https://github.com/janestreet/ppx_expect) library.
Install it with:

```
opam install ppx_expect
```

And add `ppx_expect` to the dune file of your test directory, after `ppx_inline_test`, like this:

```
 (preprocess (pps ppx_inline_test ppx_expect)))
```

## ocamlformat

We recommend installing the [ocamlformat](https://github.com/ocaml-ppx/ocamlformat?tab=readme-ov-file#------ocamlformat--) tool:
```
opam install ocamlformat
```

If your project contains the [.ocamlformat](.ocamlformat) file, ocamlformat
will automatically format your code whenever you save your source file or press <kbd>Ctrl</kbd>+<kbd>S</kbd>, adding indentation and whitespace where appropriate.

You can also invoke the tool manually with:
```
dune fmt
```

Please format your code with the above command before handing in the project.

## Resources

* [The Rust Handbook](https://doc.rust-lang.org/book/title-page.html)
  - [What Is Ownership?](https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html)
  - [The Stack and the Heap](https://web.mit.edu/rust-lang_v1.25/arch/amd64_ubuntu1404/share/doc/rust/html/book/first-edition/the-stack-and-the-heap.html)
* [The Rust Reference](https://doc.rust-lang.org/reference/introduction.html?search=). Useful for developing the grammar.
  - [Statements and expressions](https://doc.rust-lang.org/reference/statements-and-expressions.html)
* [OCaml language guide](https://ocaml.org/docs/values-and-functions). Interesting articles:
  - [Records](https://ocaml.org/docs/basic-data-types#records)
  - [Mutability](https://ocaml.org/docs/mutability-imperative-control-flow)
* [ocamllex manual](https://ocaml.org/manual/5.2/lexyacc.html#)
  - [Regular expression syntax](https://ocaml.org/manual/5.2/lexyacc.html#ss:ocamllex-regexp)
* [Menhir manual](https://cambium.inria.fr/~fpottier/menhir/manual.html)
  - [The standard library](https://cambium.inria.fr/~fpottier/menhir/manual.html#sec38)
* [Setting up Visual Studio Code for OCaml](https://ocaml.org/docs/set-up-editor#visual-studio-code)

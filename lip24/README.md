# Tiny Rust

*Unit tests coming soon.*


Initialize the project with:
```
dune init proj tinyrust
```

Build your code and run the tests interactively with:
```
dune test --watch
```

We encourage you to use the data structures provided by the [OCaml standard library](https://ocaml.org/manual/5.2/api/index.html) wherever you see fit. To name a few: [Stack](https://ocaml.org/manual/5.2/api/Stack.html), [Hashtbl](https://ocaml.org/manual/5.2/api/Hashtbl.html), [Array](https://ocaml.org/manual/5.2/api/Array.html), [Result](https://ocaml.org/manual/5.2/api/Result.html), [Option](https://ocaml.org/manual/5.2/api/Option.html)...

Your project may also depend on external opam libraries. For example, to get nice error messages from the parser, you can use the [nice-parser](https://ocaml.org/p/nice_parser/latest) library.
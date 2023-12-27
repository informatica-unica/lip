# 🤖 LIP23 project: CROBOTS 🤖

Define the parser and the small-step semantics of small battle robots competing in the programming game [CROBOTS](https://crobots.deepthought.it/home.php).

In order to make the project work you'll need to:
- define a lexer in `lib/lexer.mll`
- define a parser in `lib/parser.mly`
- implement the interfaces `lib/memory.mli` and `lib/trace.mli`

## Run the project

Run the project with two example robots:
```bash
dune exec crobots -- test/rabbit test/rook
```

## Run tests

```bash
dune test
```
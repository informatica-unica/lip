# 🤖 LIP23 project: CROBOTS 🤖

Define the parser and the small-step semantics of small battle robots competing in the programming game [CROBOTS](https://crobots.deepthought.it/home.php).

In order to make the project work you'll need to:
- define a lexer in `lib/lexer.mll`
- define a parser in `lib/parser.mly`
- implement the interfaces `lib/memory.mli` and `lib/trace.mli`

## Run the project

Run the project with two sample robots:

```bash
dune exec crobots test/rabbit test/rook
```

You should see the following output:

```
test/rabbit compiled with no errors.
test/rook compiled with no errors.
test/rabbit was hit by test/rook's missile (D%: 11)
test/rabbit was hit by test/rook's missile (D%: 16)
test/rabbit was hit by test/rook's missile (D%: 20)
test/rook hit east wall (D%: 5)
test/rabbit was hit by test/rook's missile (D%: 32)
test/rabbit was hit by test/rook's missile (D%: 42)
test/rook hit west wall (D%: 10)
test/rabbit was hit by test/rook's missile (D%: 49)
test/rabbit was hit by test/rook's missile (D%: 57)
test/rabbit was hit by test/rook's missile (D%: 63)
test/rabbit was hit by test/rook's missile (D%: 68)
test/rook hit east wall (D%: 15)
test/rabbit was hit by test/rook's missile (D%: 72)
test/rabbit was hit by test/rook's missile (D%: 74)
test/rabbit was hit by test/rook's missile (D%: 83)
test/rabbit was hit by test/rook's missile (D%: 89)
test/rabbit was hit by test/rook's missile (D%: 94)
test/rabbit was hit by test/rook's missile (D%: 100)
test/rabbit was killed by test/rook's missile
test/rook is the winner
```

## Run tests

```bash
dune test
```

## Format your code

```bash
dune fmt
```

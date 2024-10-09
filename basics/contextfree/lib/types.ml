type symbol = A | B | S

type terminal = char
type symbol_or_terminal = NT of symbol | T of terminal
type sentential_form = symbol_or_terminal list
type production = symbol * sentential_form

type grammar = {
  symbols : symbol list;
  terminals : terminal list;
  productions : production list;
  start : symbol;
}
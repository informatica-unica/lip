exception NoRuleApplies

type state = Memory.environment * Memory.memory
type conf = St | Ret of int | Instr of Ast.instruction

val trace1_expr : Ast.expression -> Ast.expression

val trace_expr : Ast.expression -> Ast.expression list

val trace1_instr : conf -> conf

val trace_instr : conf -> conf list
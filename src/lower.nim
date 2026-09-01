import tokens
import std/strformat
import tables
import std/os

type
  Transpiler = object
    scope: Table[string, bool] # Identifier to mutability
    content: string

proc remove_newlines(tokens: var seq[Token]): int =
  var newlines_removed = false
  var count = 0;
  while not newlines_removed:
    var cur = tokens[0]
    if cur.kind == "NEWLINE":
      count += 1
      tokens.delete(0)
    else:
      newlines_removed = true
  return count

proc expect_value(tp: var Transpiler, tokens: var seq[Token]) =
  var cur = tokens[0]
  if cur.kind == "NUMBER":
    tp.content.add(fmt"{cur.value}")
  elif cur.kind == "STRING":
    insert(tp.content, ": cstring ", tp.content.len - 3)
    tp.content.add(&"{cur.value}")
  elif cur.kind == "IDENTIFIER":
    tp.content.add(cur.value)
    tokens.delete(0)
  else:
    quit(fmt"Error: Expected value found {cur.value}")

  tokens.delete(0)

proc expect_equal(tp: var Transpiler, tokens: var seq[Token]) =
  var cur = tokens[0]
  if cur.kind != "EQUAL":
    quit(fmt"Error: Expected EQUAL found {cur.value}")
  tp.content.add(fmt"= ")
  tokens.delete(0)

proc expect_assignment(tp: var Transpiler, tokens: var seq[Token], mutable: bool) =
  var cur = tokens[0]
  if cur.kind != "IDENTIFIER":
    quit(fmt"Error: Expected IDENTIFIER found {cur.value}")
  if tp.scope.hasKey(cur.value):
    if tp.scope[cur.value] == false:
      quit(fmt"Error: Cannot change immutable variable {cur.value}")
    tp.content.add(&"\n{cur.value} ")
  else:
    if mutable:
      tp.content.add(&"\nvar {cur.value} ")
      tp.scope[cur.value] = mutable
    else:
      tp.content.add(&"\nlet {cur.value} ")
      tp.scope[cur.value] = mutable

  tokens.delete(0)
  expect_equal(tp, tokens)
  expect_value(tp, tokens)

proc expect_statement(tp: var Transpiler, tokens: var seq[Token]) =
  var cur = tokens[0]
  if cur.kind == "IDENTIFIER":
    expect_assignment(tp, tokens, false)
  elif cur.kind == "MUTABLE":
    tokens.delete(0)
    expect_assignment(tp, tokens, true)
  elif cur.kind == "ECHO":
    tp.content.add("\necho ")
    tokens.delete(0)
    expect_value(tp, tokens)
  elif cur.kind == "USE":
      tokens.delete(0)
      cur = tokens[0]

      var path = findExe("bn")
      var parent = parentDir(path)
      var standard_library = parent / "runtime" / (cur.value & ".a")

      tp.content.add("{.passL: \"" & standard_library & "\".}\n")

      if cur.value == "math":
          tp.content.add("""
proc rs_add(a: int32, b: int32): int32 {.importc.}
proc rs_sub(a: int32, b: int32): int32 {.importc.}
proc rs_mult(a: int32, b: int32): int32 {.importc.}
proc rs_int_div(a: int32, b: int32): int32 {.importc.}
""")
      tokens.delete(0)
  else:
    quit(fmt"Error: Expected identifer found {cur.value}")

proc transpile(tp: var Transpiler, tokens: var seq[Token]): string =
  var found_end_of_file = false
  while not found_end_of_file:
    var newlines = remove_newlines(tokens)
    let cur = tokens[0]
    if cur.kind == "EOF":
      found_end_of_file = true
      break
    expect_statement(tp, tokens)

  tp.content

# Target is either LLVM IR or Nim
proc lower*(tokens: var seq[Token], target: string): string =
  # Either transpile to Nim or generate LLVM IR (codegen)
  if target == "llvm":
    return ""
  else:
    var transpiler = Transpiler(
      scope: initTable[string, bool](),
      content: ""
    )
    return transpile(transpiler, tokens)

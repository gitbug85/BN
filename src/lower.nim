import tokens
import std/strformat
import tables

type
  Transpiler = object
    scope: Table[string, string] # Identifier to mutability
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

proc expect_value(tokens: var seq[Token], content: var string) =
  var cur = tokens[0]
  if cur.kind == "NUMBER":
    content.add(fmt"{cur.value}")
  elif cur.kind == "STRING":
    content.add(&"{cur.value}")
  elif cur.kind == "IDENTIFIER":
    content.add(cur.value)
    tokens.delete(0)
  else:
    quit(fmt"Error: Expected value found {cur.value}")

  tokens.delete(0)

proc expect_equal(tokens: var seq[Token], content: var string) =
  var cur = tokens[0]
  if cur.kind != "EQUAL":
    quit(fmt"Error: Expected EQUAL found {cur.value}")
  content.add(fmt"= ")
  tokens.delete(0)
  expect_value(tokens, content)

proc expect_identifier(tokens: var seq[Token], content: var string) =
  var cur = tokens[0]
  if cur.kind != "IDENTIFIER":
    quit(fmt"Error: Expected IDENTIFIER found {cur.value}")
  content.add(&"\nvar {cur.value} ")
  tokens.delete(0)
  expect_equal(tokens, content)

proc expect_statement(tokens: var seq[Token], content: var string) =
  var cur = tokens[0]
  if cur.kind == "IDENTIFIER":
    content.add(&"\nvar {cur.value} ")
    tokens.delete(0)
    expect_equal(tokens, content)
  elif cur.kind == "MUTABLE":
    tokens.delete(0)
    expect_identifier(tokens, content)
  elif cur.kind == "ECHO":
    content.add("\necho ")
    tokens.delete(0)
    expect_value(tokens, content)
  else:
    quit(fmt"Error: Expected identifer found {cur.value}")

proc transpile(tokens: var seq[Token]): string =
  var content = ""
  var found_end_of_file = false
  while not found_end_of_file:
    var newlines = remove_newlines(tokens)
    let cur = tokens[0]
    if cur.kind == "EOF":
      found_end_of_file = true
      break
    expect_statement(tokens, content)

  content

# Target is either LLVM IR or Nim
proc lower*(tokens: var seq[Token], target: string): string =
  # Either transpile to Nim or generate LLVM IR (codegen)
  if target == "llvm":
    return ""
  else:
    return transpile(tokens)

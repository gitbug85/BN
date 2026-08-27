import tokens
import std/strformat

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

proc expect_identifier(tokens: var seq[Token], content: var string) =
  var cur = tokens[0]
  if cur.kind != "IDENTIFIER":
    quit(fmt"Error: Expected identifer found {cur.value}")
  content.add(&"\nvar {cur.value} ")
  tokens.delete(0)

proc expect_is(tokens: var seq[Token], content: var string) =
  var cur = tokens[0]
  if cur.kind != "IS":
    quit(fmt"Error: Expected IS found {cur.value}")
  content.add(fmt"= ")
  tokens.delete(0)

proc expect_value(tokens: var seq[Token], content: var string) =
  var cur = tokens[0]
  if cur.kind == "NUMBER":
    content.add(fmt"{cur.value}")
  elif cur.kind == "STRING":
    content.add(&"{cur.value}")
  else:
    quit(fmt"Error: Expected value found {cur.value}")

  tokens.delete(0)

proc transpile*(tokens: var seq[Token]): string =
  var content = ""

  var found_end_of_file = false
  while not found_end_of_file:
    var newlines = remove_newlines(tokens)
    let cur = tokens[0]
    if cur.kind == "EOF":
      found_end_of_file = true
      break
    expect_identifier(tokens, content)
    expect_is(tokens, content)
    expect_value(tokens, content)

  content

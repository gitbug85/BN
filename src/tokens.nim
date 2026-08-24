import std/strutils

type
  Token* = object
    kind*: string
    value*: string

proc tokenize*(path: string): seq[Token] =
  let content = readFile(path)
  let allLines: seq[string] = content.splitLines()

  for line in allLines:
    echo line

  result.add(Token(kind: "Identifier", value: "x"))

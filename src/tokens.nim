import std/strutils

type
  Token* = object
    kind*: string
    value*: string

proc isQuotedString(s: string): bool =
  return s.len >= 2 and s.startsWith("\"") and s.endsWith("\"")

proc isNumber(s: string): bool =
  try:
    discard parseInt(s)
    return true
  except ValueError:
    return false

proc tokenize*(path: string): seq[Token] =
  let content = readFile(path)
  let allLines: seq[string] = content.splitLines()
  let separators = {'=', '(', ')', ' '}

  for line in allLines:
    var lexemes: seq[string] = line.split(separators)

    for lexeme in lexemes:
      if lexeme.len == 0:
          continue

      case lexeme
      of "ARGS":
        result.add(Token(kind: "ARGS", value: lexeme))
      of "IS":
        result.add(Token(kind: "IS", value: lexeme))
      of "PRINT":
        result.add(Token(kind: "PRINT", value: lexeme))
      else:
        if isNumber(lexeme):
          result.add(Token(kind: "NUMBER", value: lexeme))
        elif isQuotedString(lexeme):
          result.add(Token(kind: "STRING", value: lexeme))
        else:
          result.add(Token(kind: "IDENTIFIER", value: lexeme))
    result.add(Token(kind: "NEWLINE", value: "\n"))

  result.add(Token(kind: "EOF", value: ""))

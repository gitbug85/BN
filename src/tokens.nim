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

proc removeAfter(s: string, sub: char): string =
  let idx = s.find(sub)
  if idx == 0:
    return ""
  elif idx > 0:
    return s[0 .. idx-1]
  return s

proc tokenize*(path: string): seq[Token] =
  let content = readFile(path)
  var allLines: seq[string] = content.splitLines()
  let separators = {' '}

  for line in allLines.mitems:
    line = removeAfter(line, '#')
    var lexemes: seq[string] = line.split(separators)

    for lexeme in lexemes:
      if lexeme.len == 0:
          continue

      case lexeme
      of "ARGS":
        result.add(Token(kind: "ARGS", value: lexeme))
      of "=":
        result.add(Token(kind: "EQUAL", value: lexeme))
      of "echo":
        result.add(Token(kind: "ECHO", value: lexeme))
      of "mut":
        result.add(Token(kind: "MUTABLE", value: lexeme))
      else:
        if isNumber(lexeme):
          result.add(Token(kind: "NUMBER", value: lexeme))
        elif isQuotedString(lexeme):
          result.add(Token(kind: "STRING", value: lexeme))
        else:
          result.add(Token(kind: "IDENTIFIER", value: lexeme))
    result.add(Token(kind: "NEWLINE", value: "\n"))

  result.add(Token(kind: "EOF", value: ""))

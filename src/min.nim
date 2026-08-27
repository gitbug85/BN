import std/parseopt
import tokens
import std/os
import transpilation

var p = initOptParser()

var command = ""
var path = ""

while true:
  p.next()

  case p.kind
  of cmdEnd:
    break

  of cmdShortOption, cmdLongOption:
    echo "Option: ", p.key, " = ", p.val

  of cmdArgument:
    if command == "":
      command = p.key
    elif command == "c" and path == "":
      path = p.key
    else:
      quit("Unexpected argument: " & p.key, 1)

if command == "c":
  if path == "":
    quit("Usage: myprogram c <path>", 1)

  if not fileExists(path):
    quit "File not found!"

  var tokens: seq[Token] = tokenize(path)
  for tok in tokens:
    echo tok.kind
  var content = transpile(tokens)
  echo content
  let parent = parentDir(path)
  let (_, stem, _) = splitFile(path)
  let basename = stem & ".nim"
  let full_path = parent / basename
  writeFile(full_path, content)

else:
  quit("Unknown command: " & command, 1)

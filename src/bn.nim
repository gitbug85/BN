import std/parseopt
import tokens
import std/os
import transpilation
import std/strformat
import osproc

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

  let fileInfo = splitFile(path)
  if not (fileInfo.ext == ".bn"):
    quit "Incorrect file extension!"

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
  let output = execProcess(fmt"nim c {full_path}")
  echo "Output: ", output
  removeFile(full_path)

else:
  quit("Unknown command: " & command, 1)

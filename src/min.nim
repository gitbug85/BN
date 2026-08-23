import std/parseopt
import compile

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

  echo "Compiling: ", path
else:
  quit("Unknown command: " & command, 1)

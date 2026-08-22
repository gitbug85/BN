import std/parseopt

var p = initOptParser()

var command = ""
var target = ""
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
    elif command == "c" and target == "":
      target = p.key
    elif command == "c" and path == "":
      path = p.key
    else:
      quit("Unexpected argument: " & p.key, 1)

if command == "c":
  if target notin ["bin", "py", "nim"]:
    quit("Invalid compile target: " & target, 1)

  if path == "":
    quit("Missing path", 1)

  echo "Compiling ", path, " -> ", target
else:
  quit("Unknown command: " & command, 1)

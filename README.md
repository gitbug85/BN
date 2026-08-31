# Borrow Nim

Nim and Rust inspired language.\
I "borrowed" Nim to make this language but I will also try to add a borrow checker.\
Compile bn.nim for the compiler executable. Then run a command through it like ```./bn c ./example.bn```

This is what it can currently do.
```
# This prints Hello world! to the console
mut greeting = "Hi world!" # Assignment
greeting = "Hello world!" # Reassignment taking into account mutablity
echo greeting
```

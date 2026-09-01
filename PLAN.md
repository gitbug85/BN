# TODO
- X Make reassignment take into account mutability -> Scope!
- Add standard library

# Stratagy

I find both Nim and Rust to have features I like but some downsides.
I will start from very basic syntax and the build the language from there.
The language will at first transpile to Nim then compile to binary but eventually I will switch to immediate LLVM compilation.

Things I like from different programming languages that I want to implement:
- Nim: Small join paths operator
- Python: Small constructors
- Ruby: Small current instance references
- Rust: Borrow checker
- Nim: Indentation-based syntax
- Rust: Explicit mutability

Unique things I want to implement:
- Small operators
- Left Operand Wins: Whatever operand type is on the left is the output of the operation

|               | **Fixed Type** | **Flexible Type** |
| ------------- | -------------- | ----------------- |
| **Immutable** | `x = 5`        | `flex x = 5`      |
| **Mutable**   | `mut x = 5`    | `mutflex x = 5`   |

prot: immutable & inflexable reference
ref: reference

use -> runtime
imp -> everything else

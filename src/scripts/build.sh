nim c ./src/bn.nim
rustc --crate-type=staticlib ./src/runtime/math.rs -o ./src/runtime/math.a
rustc --crate-type=staticlib ./src/runtime/cli.rs -o ./src/runtime/cli.a
rustc --crate-type=staticlib ./src/runtime/string.rs -o ./src/runtime/string.a

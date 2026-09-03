nim c ../bn.nim
rustc --crate-type=staticlib ../runtime/math.rs -o ../runtime/math.a
rustc --crate-type=staticlib ../runtime/cli.rs -o ../runtime/cli.a
rustc --crate-type=staticlib ../runtime/string.rs -o ../runtime/string.a

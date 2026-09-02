nim c ../bn.nim
rustc --crate-type=staticlib ../runtime/math.rs -o ../runtime/math.a
rustc --crate-type=staticlib ../runtime/cli.rs -o ../runtime/cli.a
rustc --crate-type=staticlib ../runtime/string.rs -o ../runtime/string.a
if ! command -v bn >/dev/null 2>&1; then
    BN_DIR="$(cd "$(dirname "../bn")" && pwd)"
    echo "export PATH=\"\$PATH:$BN_DIR\"" >> ~/.bashrc
    export PATH="$PATH:$BN_DIR"
fi

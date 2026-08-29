if ! ldconfig -p 2>/dev/null | grep -q 'libpcre\.so'; then
    echo "libpcre not found. Installing libpcre3..."
    sudo apt update
    sudo apt install -y libpcre3
else
    echo "libpcre found."
fi

nim c ../bn.nim
../bn c ../fun/greeting.bn
../bn c ../fun/ascii_art_expressions.bn

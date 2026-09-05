
# Echo inspired by nim but functionally slightly different
proc nim_echo*(s: cstring): void =
    stdout.write(s)

# Say is inspired by Perl
proc nim_say*(s: cstring): void =
    echo s
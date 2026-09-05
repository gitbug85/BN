use feature 'class';

class Lexeme {
    field $col;
    field $ln;
    field $val;
}

sub lex {
    my $filename = shift;
    my @lexemes;
    
    open(my $fh, '<:encoding(UTF-8)', $filename) 
        or die "Could not open file '$filename': $!";

    while (my $line = <$fh>) {
        chomp $line;
        
        push @lexemes, Lexeme->new(0, 0, $line);
        print "Processing: $line\n";
}
}
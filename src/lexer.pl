use feature 'class';
no warnings 'experimental::class';

class Lexeme {
    field $col :param;
    field $ln  :param;
    field $val :param;
}

sub lex {
    my $filename = shift;
    my @lexemes;
    
    open(my $fh, '<:encoding(UTF-8)', $filename) 
        or die "Could not open file '$filename': $!";

    while (my $line = <$fh>) {
        chomp $line;
        
        push @lexemes, Lexeme->new(col => 0, ln => 0, val => $line);
        print "Processing: $line\n";
    }
}

my $input_file = $ARGV[0]; 

if ($input_file) {
    lex($input_file);
} else {
    die "No input file path was provided to the Perl script.\n";
}
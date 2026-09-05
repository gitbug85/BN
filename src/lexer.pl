use feature 'class';
use JSON::PP;
no warnings 'experimental::class';

class Segment {
    field $col :param;
    field $ln  :param;
    field $val :param;
}

use constant {
    JOINING_STRING => 0,
    JOINING_PATH => 1,
    NOT_JOINING => 2,
};

sub TO_JSON {
    my $self = shift;
    return { %$self };
}

sub lex {
    my $filename = shift;
    my @fragments;
    
    open(my $fh, '<:encoding(UTF-8)', $filename) 
        or die "Could not open file '$filename': $!";

    # Make fragments based on spaces
    while (my $line = <$fh>) {
        chomp $line;
        print "Processing: $line\n";

        my $current_fragment = "";
        my @chars = split('', $line);
        my $space = " ";

        for my $i (0 .. $#chars) {
            if ($chars[$i] == $space) {
                if (current_fragment != "") {
                    push @fragments, Segment->new(col => $i, ln => $., val => current_fragment);
                    $current_fragment = "";
                }
                push @fragments, Segment->new(col => $i, ln => $., val => $space);
            }
            $current_fragment .= $chars[$i]
        }
        
        push @fragments, Segment->new(col => 0, ln => $., val => $line);
    }

=pod
    Join fragments together to make lexemes:
     - Strings ""
     - Paths ``
     Everything else is one to one.
=cut

    my $lexing_status = NOT_JOINING;
    my @lexemes;

    # Add code here for making lexemes

    # Convert to json and return json string
    my @plain_fragments = map { { %$_ } } @fragments; # Use fragments for now but switch to lexemes
    my $json_encoder = JSON::PP->new;
    my $json_string  = $json_encoder->encode(\@plain_fragments);

    print $json_string, "\n";
}

my $input_file = $ARGV[0]; 

if ($input_file) {
    lex($input_file);
} else {
    die "No input file path was provided to the Perl script.\n";
}
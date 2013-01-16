use MooseX::Declare;
class Symbols::Type extends Lexer::Word {

    #BUILD (lexeme=> Str, tag => Num, width => Num)
    use lib '../';
    use MooseX::ClassAttribute;
    use Lexer::Tag;

    has 'width' => (    #width is used for storage allocation
        is      => 'rw',
        isa     => 'Num',
        default => 0,
    );

    for (qw(Int Float Char Bool)) {
        class_has $_ => (
            is      => 'rw',
            isa     => 'Symbols::Type',
            default => sub {
                Symbols::Type->new( lexeme => ( lc $_ ), Lexer::Tag->BASIC, 4 );
            },
        );
    }

    sub numeric {    #class method
        my $p = shift;
        return 1
          if ( $p == Symbols::Type->Char
            or $p == Symbols::Type->Int
            or $p == Symbols::Type->Float );
        return 0;
    }

    sub max {        #class method
        my ( $p1, $p2 ) = @_;
        if ( not numeric($p1) or not numeric($p2) ) {
            return undef;
        }
        elsif ( $p1 == Symbols::Type->Float or $p2 == Symbols::Type->Float ) {
            return Symbols::Type->Float;
        }
        elsif ( $p1 == Symbols::Type->Int or $p2 == Symbols::Type->Int ) {
            return Symbols::Type->Int;
        }
        else {
            return Symbols::Type->Char;
        }
    }
}

1;

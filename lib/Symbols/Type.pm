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

    my %hash = (

        #type=>width
        Int   => 4,
        Float => 8,
        Char  => 1,
        Bool  => 1,
    );

    for ( keys %hash ) {
        class_has $_ => (
            is      => 'rw',
            isa     => 'Symbols::Type',
            default => sub {
                Symbols::Type->new(
                    lexeme => ( lc $_ ),
                    tag    => Lexer::Tag->BASIC,
                    width  => $hash{$_}
                );
            },
        );
    }

    sub numeric {    #class method
        my ( $class, $p ) = @_;
        return 1
          if ( $p == Symbols::Type->Char
            or $p == Symbols::Type->Int
            or $p == Symbols::Type->Float );
        return 0;
    }

    sub max {        #class method
        my ( $class, $p1, $p2 ) = @_;
        if (   not Symbols::Type->numeric($p1)
            or not Symbols::Type->numeric($p2) )
        {
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

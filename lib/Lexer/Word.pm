use lib '../../lib';
use MooseX::Declare;

class Lexer::Word extends Lexer::Token {

    #--BUILD (lexeme=> Str, tag => Num)
    use Lexer::Token;
    use Lexer::Tag;
    use MooseX::ClassAttribute;

    has 'lexeme' => (
        is  => 'rw',
        isa => 'Str',
    );

    method to_string { $self->lexeme; }

    my %hash = (

        #var => [lexeme, tag]
        and   => [ '&&',    Lexer::Tag->AND ],
        or    => [ '||',    Lexer::Tag->OR ],
        eq    => [ '==',    Lexer::Tag->EQ ],
        ne    => [ '!=',    Lexer::Tag->NE ],
        le    => [ '<=',    Lexer::Tag->LE ],
        ge    => [ '>=',    Lexer::Tag->GE ],
        minus => [ 'minus', Lexer::Tag->MINUS ],
        temp  => [ 't',     Lexer::Tag->TEMP ],
        True  => [ 'true',  Lexer::Tag->TRUE ],
        False => [ 'false', Lexer::Tag->FALSE ],
    );

    for ( keys %hash ) {
        class_has $_ => (
            is      => 'ro',
            isa     => 'Lexer::Word',
            default => sub {
                Lexer::Word->new(
                    lexeme => $hash{$_}[0],
                    tag    => $hash{$_}[1]
                );
            },
        );
    }
}

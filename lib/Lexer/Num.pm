use MooseX::Declare;
use lib '../../lib';
class Lexer::Num extends Lexer::Token {

    #--BUILD (value=>Num)
    use Lexer::Token;
    use Lexer::Tag;

    has 'value' => (
        is  => 'rw',
        isa => 'Num',
    );

    method BUILD {
        $self->tag( Lexer::Tag->NUM );
    }

    method to_string {
        return $self->tag . "";
    }
}

1;

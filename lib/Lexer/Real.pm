use MooseX::Declare;
use lib '../../lib';    #dev
class Lexer::Real extends Lexer::Token {

    #--BUILD (value=>Num)
    use Lexer::Token;
    use Lexer::Tag;

    has 'value' => (
        is  => 'rw',
        isa => 'Num',
    );

    method BUILD {
        $self->tag( Lexer::Tag->REAL );
    }

    method to_string {
        return $self->tag . "";
    }

}

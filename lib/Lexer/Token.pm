use MooseX::Declare;

class Lexer::Token {

    #--BUILD (tag=>Num)
    has 'tag' => (
        is  => 'rw',
        isa => 'Num',
    );

    method to_string {
        return $self->tag . "";
    }

}

1;

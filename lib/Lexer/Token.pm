use MooseX::Declare;

class Lexer::Token {

    #--BUILD (tag=>Num)
    has 'tag' => (
        is  => 'rw',
        isa => 'Num',
    );

    method to_string {
        chr $self->tag;
    }

}

1;

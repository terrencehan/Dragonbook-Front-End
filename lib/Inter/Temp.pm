use MooseX::Declare;

class Inter::Temp extends Inter::Expr {

    #--BUILD (type => Symbols::Type)
    use lib '../';

    use MooseX::ClassAttribute;
    use Lexer::Word;

    class_has 'count' => (
        is      => 'rw',
        isa     => 'Num',
        default => 0,
    );

    has 'number' => (
        is      => 'rw',
        isa     => 'Num',
        default => 0,
    );

    method BUILD {
        $self->op(Lexer::Word->temp);
        $self->number( Inter::Temp->count( Inter::Temp->count + 1 ) );
    }

    method to_string {
        "t" . $self->number;
    }

}

1;

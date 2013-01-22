use MooseX::Declare;

class Inter::Access extends Inter::Op {

    #--BUILD (array => Inter::Id, index => Inter::Expr, type => Symbols::Type)
    use lib '../';
    use Inter::Temp;

    has 'array' => (
        is  => 'rw',
        isa => 'Inter::Id',
    );

    has 'index' => (
        is  => 'rw',
        isa => 'Inter::Expr',
    );

    method BUILD {
        $self->op(
            Lexer::Word->new( lexeme => "[]", tag => Lexer::Tag->INDEX ) );
    }

    method gen {
        Inter::Access->new(
            array => $self->array,
            index => $self->index->reduce,
            type  => $self->type
        );
    }

    method jumping (Num $t, Num $f) {
        $self->emitjumps( $self->reduce->to_string, $t, $f );
    }

    method to_string {
        $self->array->to_string . " [" . $self->index->to_string . " ]";
    }

}

1;

use MooseX::Declare;

class Inter::Arith extends Inter::Op {

    #---BUILD (op=> Lexer::Token, expr1=>Inter::Expr, expr2=>Inter::Expr)
    use lib '../';
    has [ 'expr1', 'expr2' ] => (
        is  => 'rw',
        isa => 'Inter::Expr',
    );

    method BUILD {
        my $t = Symbols::Type->max( $self->expr1->type, $self->expr2->type );
        if ( not defined $t ) {
            $self->error("type error");
        }
        $self->type($t);
    }

    method gen {
        Inter::Arith->new(
            op    => $self->op,
            expr1 => $self->expr1->reduce,
            expr2 => $self->expr2->reduce,
        );
    }

    method to_string {
        $self->expr1->to_string . " "
          . $self->op->to_string . " "
          . $self->expr2->to_string;
    }

}

1;

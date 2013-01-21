use MooseX::Declare;

class Inter::Unary extends Inter::Op {

    #---BUILD (op=> Lexer::Token, expr=>Inter::Expr)
    use lib '../';
    has 'expr' => (
        is  => 'rw',
        isa => 'Inter::Expr',
    );

    method BUILD {
        my $t = Symbols::Type->max( Symbols::Type->Int, $self->expr->type );
        if ( not defined $t ) {
            $self->error("type error");
        }
        $self->type($t);
    }

    method gen {
        Inter::Arith->new(
            op   => $self->op,
            expr => $self->expr->reduce,
        );
    }

    method to_string {
        $self->op->to_string . " " . $self->expr->to_string;
    }

}

1;

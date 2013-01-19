use MooseX::Declare;

class Inter::Op extends Inter::Expr {

    #--BUILD {op=> Lexer::Token, type => Symbols::Type}
    use lib '../';
    use Inter::Temp;

    method reduce {
        my $x = $self->gen;
        my $t = Inter::Temp->new;
        $self->emit( $t->to_string . " = " . $x->to_string );
        $t;
    }
}

1;

use MooseX::Declare;
class Inter::Rel extends Inter::Logical {

    #---BUILD (op=> Lexer::Token, expr1=>Inter::Expr, expr2=>Inter::Expr)
    use lib '../';

    sub check {
        my ( $class, $type1, $type2 ) = @_;
        if (   ref($type1) eq 'Symbols::Array'
            or ref($type2) eq 'Symbols::Array' )
        {
            undef;
        }
        elsif ( $type1 == $type2 ) {
            Symbols::Type->Bool;
        }
        else {
            undef;
        }
    }

    method jumping (Num $t, Num $f) {
        my $a = $self->expr1->reduce;
        my $b = $self->expr2->reduce;
        my $test =
          $a->to_string . " " . $self->op->to_string . " " . $b->to_string;
        $self->emitjumps( $test, $t, $f );
    }

}

use MooseX::Declare;
class Inter::And extends Inter::Logical {

    #---BUILD (op=> Lexer::Token, expr1=>Inter::Expr, expr2=>Inter::Expr)
    use lib '../';

    method jumping (Num $t, Num $f) {
        my $label = $f != 0 ? $f : $self->newlabel;
        $self->expr1->jumping( 0,  $label );
        $self->expr2->jumping( $t, $f );
        $self->emitlabel($label) if $f == 0;
    }

}

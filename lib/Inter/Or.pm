use MooseX::Declare;
class Inter::Or extends Inter::Logical {

    #---BUILD (op=> Lexer::Token, expr1=>Inter::Expr, expr2=>Inter::Expr)
    use lib '../';

    method jumping (Num $t, Num $f) {
        my $label = $t != 0 ? $t : $self->newlabel;
        $self->expr1->jumping( $label, 0 );
        $self->expr2->jumping( $t,     $f );
        $self->emitlabel($label) if $t == 0;
    }

}

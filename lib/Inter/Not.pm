use MooseX::Declare;
class Inter::Not extends Inter::Logical {

    #---BUILD (op=> Lexer::Token, expr1=>Inter::Expr, expr2=>Inter::Expr)
    use lib '../';

    method jumping (Num $t, Num $f) {
        $self->expr2->jumping( $f, $t );
    }

    method to_string {
        $self->op->to_string . " " . $self->expr2->to_string;
    }

}

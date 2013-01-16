use MooseX::Declare;
class Inter::Expr extends Inter::Node {

    #--BUILD (op=> Lexer::Token, type => Symbols::Type)
    use lib '../';
    use Lexer::Token;
    use Symbols::Type;

    has 'op' => (
        is  => 'rw',
        isa => 'Lexer::Token',
    );

    has 'type' => (
        is  => 'rw',
        isa => 'Symbols::Type',
    );

    method gen    { return $self; }
    method reduce { return $self; }

    method emitjumps (Str $test, Num $t, Num $f) {
        if ( $t != 0 && $f != 0 ) {
            $self->emit( 'if ' . $test . " goto L" . $t );
            $self->emit( 'goto L' . $f );
        }
        elsif ( $t != 0 ) { $self->emit( 'if ' . $test + ' goto L' . $t ); }
        elsif ( $f != 0 ) {
            $self->emit( 'iffalse ' . $test . ' goto L' . $f );
        }
        else {
            #nothing since both t and f fall through
        }
    }

    method to_string { return $self->op->to_string; }
}

1;

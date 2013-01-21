use MooseX::Declare;
class Inter::Expr extends Inter::Node {

    #--BUILD (op=> Lexer::Token, type => Symbols::Type)
    use lib '../';
    use Lexer::Token;
    use Symbols::Type;

    has 'op' => (    #oprator
        is  => 'rw',
        isa => 'Lexer::Token',
    );

    has 'type' => (
        is  => 'rw',
        isa => 'Symbols::Type',
    );

    method gen {

      #return a 'term' that can fit the right side of a tree-address instruction
        $self;
    }

    method reduce {

        #compute or "reduce" an expression down to a single address
        $self;
    }

    method jumping (Num $t, Num $f) { 
        #true and false, label number (i.e. 'L1').
        #By convention, the special label 0 means that
        #control falls through B to the next instruction
        #after the code for B.
        $self->emitjumps( $self->to_string, $t, $f );
    }

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

    method to_string { $self->op->to_string; }
}

1;

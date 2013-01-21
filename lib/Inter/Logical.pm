use MooseX::Declare;

class Inter::Logical extends Inter::Expr {

    #---BUILD (op=> Lexer::Token, expr1=>Inter::Expr, expr2=>Inter::Expr)
    use lib '../';
    use Inter::Temp;
    has [ 'expr1', 'expr2' ] => (
        is  => 'rw',
        isa => 'Inter::Expr',
    );

    method BUILD {
        my $t = Inter::Logical->check( $self->expr1->type, $self->expr2->type );
        if ( not defined $t ) {
            $self->error("type error");
        }
        $self->type($t);
    }

    sub check {
        my ( $class, $type1, $type2 ) = @_;
        if ( $type1 == Symbols::Type->Bool and $type2 == Symbols::Type->Bool ) {
            return Symbols::Type->Bool;
        }
        else {
            return undef;
        }
    }

    method gen { #error? i think this should be 'reduce' according to the dragonbook
        my ( $f, $a ) =
          ( $self->newlabel, $self->newlabel );    #false, after => Num
        my $temp = Inter::Temp->new( type => $self->type );
        $self->jumping( 0, $f );                   #fall through when true
        $self->emit( $temp->to_string . " = true" );     # "tx = true"
        $self->emit( 'goto L' . $a );
        $self->emitlabel($f);
        $self->emit( $temp->to_string . " = false" );    # "tx = false"
        $self->emitlabel($a);
        $temp;
    }

    method to_string {
        $self->expr1->to_string . " "
          . $self->op->to_string . " "
          . $self->expr2->to_string;
    }

}

1;

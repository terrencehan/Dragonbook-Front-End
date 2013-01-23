use MooseX::Declare;
class Inter::Set extends Inter::Stmt {

    #-- BUILD (id => Inter::Id, expr => Inter::Expr)
    use lib '../';

    has id => (
        is  => 'rw',
        isa => 'Inter::Id',
    );

    has expr => (
        is  => 'rw',
        isa => 'Inter::Expr',
    );

    method BUILD {
        $self->error("type error")
          if not defined
          ref($self)->check( $self->id->type, $self->expr->type );

    }

    sub check {
        my ( $class, $type1, $type2 ) = @_;
        if ( Symbols::Type->numeric($type1) and Symbols::Type->numeric($type2) )
        {
            $type2;
        }
        elsif ( $type1 == Symbols::Type->Bool
            and $type2 == Symbols::Type->Bool )
        {
            $type2;
        }
        else {
            undef;
        }
    }

    method gen (Num $b, Num $a) {
        $self->emit( $self->id->to_string . ' = ' . $self->expr->gen->to_string );
    }

}

1;

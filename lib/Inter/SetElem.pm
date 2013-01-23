use MooseX::Declare;
class Inter::SetElem extends Inter::Stmt {

    #-- BUILD (access => Inter::Access, expr => Inter::Expr)
    use lib '../';

    has array => (
        is  => 'rw',
        isa => 'Inter::Id',
    );

    has [ 'index', 'expr' ] => (
        is  => 'rw',
        isa => 'Inter::Expr',
    );

    method BUILD ($args) {
        $self->array( $args->{access}->array );
        $self->index( $args->{access}->index );

        $self->error("type error")
          if not defined
          ref($self)->check( $args->{access}->type, $self->expr->type );
    }

    sub check {
        my ( $class, $type1, $type2 ) = @_;
        if (   ref($type1) eq 'Symbols::Array'
            or ref($type2) eq 'Symbols::Array' )
        {
            undef;
        }
        elsif ( $type1 == $type2 ) {
            $type2;
        }
        elsif ( Symbols::Type->numeric($type1)
            and Symbols::Type->numeric($type2) )
        {
            $type2;
        }
        else {
            undef;
        }
    }

    method gen (Num $b, Num $a) {
        $self->emit( $self->array->to_string . " [ "
              . $self->index->reduce->to_string . " ] = "
              . $self->expr->reduce->to_string );
    }

}

1;

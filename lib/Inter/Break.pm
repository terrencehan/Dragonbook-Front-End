use MooseX::Declare;
class Inter::Break extends Inter::Stmt {

    #-- BUILD ()
    use lib '../';

    has 'stmt' => (
        is  => 'rw',
        isa => 'Inter::Stmt',
    );

    method BUILD {
        $self->error("unenclosed break")
          if Inter::Stmt->Enclosing == Inter::Stmt->Null;

        $self->stmt( Inter::Stmt->Enclosing );
    }

    method gen (Num $b, Num $a) {
        $self->emit( "goto L" . $self->stmt->after );
    }

}

1;

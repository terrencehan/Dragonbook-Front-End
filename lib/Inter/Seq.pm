use MooseX::Declare;
class Inter::Seq extends Inter::Stmt {

    #-- BUILD (stmt1 => Inter::Stmt, stmt2 => Inter::Stmt)
    use lib '../';

    has ['stmt1', 'stmt2'] => (
        is  => 'rw',
        isa => 'Inter::Stmt',
    );


    method gen (Num $b, Num $a) {
        if($self->stmt1 == Inter::Stmt->Null){
            $self->stmt2->gen($b, $a);
        }
        elsif($self->stmt2 == Inter::Stmt->Null){
            $self->stmt1->gen($b, $a);
        }
        else{
            my $label = $self->newlabel;
            $self->stmt1->gen($b, $label);
            $self->emitlabel($label);
            $self->stmt2->gen($label, $a);
        }
    }

}

1;

use MooseX::Declare;
class Inter::Else extends Inter::Stmt {

    #handle conditionals with else parts

    #-- BUILD (expr => Inter::Expr, stmt1 => Inter::Stmt, stmt2 => Inter::Stmt)
    use lib '../';

    has expr => (
        is  => 'rw',
        isa => 'Inter::Expr',
    );

    has [ 'stmt1', 'stmt2' ] => (
        is  => 'rw',
        isa => 'Inter::Stmt',
    );

    method BUILD {
        $self->expr->error("boolen required in if")
          if $self->expr->type != Symbols::Type->Bool;
    }

    method gen (Num $b, Num $a) {
        my ( $label1, $label2 ) = ( $self->newlabel, $self->newlabel );
        $self->expr->jumping( 0, $label2 );    #fall through to stm1 on true
        $self->emitlabel($label1);
        $self->stmt1->gen( $label1, $a );
        $self->emit( "goto L" . $a );
        $self->emitlabel($label2);
        $self->stmt2->gen( $label2, $a );
    }

}

1;

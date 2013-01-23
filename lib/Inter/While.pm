use MooseX::Declare;
class Inter::While extends Inter::Stmt {

    #-- BUILD ()
    use lib '../';
    use Inter::Expr;
    use Inter::Stmt;

    has expr => (
        is  => 'rw',
        isa => 'Inter::Expr',
    );

    has stmt => (
        is  => 'rw',
        isa => 'Inter::Stmt',
    );

    method init (Inter::Expr $x, Inter::Stmt $s) {
        $self->expr($x);
        $self->stmt($s);
        $self->expr->error("boolen required in if")
          if $self->expr->type != Symbols::Type->Bool;
    }

    method gen (Num $b, Num $a) {
        $self->after($a);    #save label $a
        $self->expr->jumping( 0, $a );
        my $label = $self->newlabel;    # label for stmt
        $self->emitlabel($label);
        $self->stmt->gen( $label, $b );    # $b for next loop
        $self->emit( "goto L" . $b );      # next loop
    }

}

1;

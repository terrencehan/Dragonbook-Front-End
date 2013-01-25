use MooseX::Declare;
class Inter::Do extends Inter::Stmt {

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

    method init (Inter::Stmt $s, Inter::Expr $x) {
        $self->expr($x);
        $self->stmt($s);
        $self->expr->error("boolen required in if")
          if $self->expr->type != Symbols::Type->Bool;
    }

    method gen (Num $b, Num $a) {
        $self->after($a);    #save label $a
        my $label = $self->newlabel;    # label for expr
        $self->stmt->gen( $b, $label ); # $b for next loop
        $self->emitlabel($label);
        $self->expr->jumping( $b, 0 );
    }

}

1;

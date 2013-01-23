use MooseX::Declare;
class Inter::If extends Inter::Stmt {

    #-- BUILD (expr => Inter::Expr, stmt => Inter::Stmt)
    use lib '../';

    has expr => (
        is  => 'rw',
        isa => 'Inter::Expr',
    );

    has stmt => (
        is  => 'rw',
        isa => 'Inter::Stmt',
    );

    method BUILD {
        $self->expr->error("boolen required in if")
          if $self->expr->type != Symbols::Type->Bool;
    }

    method gen (Num $b, Num $a) {
        my $label = $self->newlabel;    # label for the code for stmt
        $self->expr->jumping( 0, $a );  # fall through on true, goto a on false
        $self->emitlabel($label);
        $self->stmt->gen( $label, $a );
    }

}

1;

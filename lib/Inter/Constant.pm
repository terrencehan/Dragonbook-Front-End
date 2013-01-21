use MooseX::Declare;

class Inter::Constant extends Inter::Expr {

    #--BUILD1 (op  => Lexer::Token, type => Symbols::Type)
    #--BUILD2 (int => Num)
    use lib '../';
    use MooseX::ClassAttribute;

    class_has 'True' => (
        is      => 'rw',
        isa     => 'Inter::Constant',
        default => sub {
            Inter::Constant->new(
                op   => Lexer::Word->True,
                type => Symbols::Type->Bool
            );
        }
    );

    class_has 'False' => (
        is      => 'rw',
        isa     => 'Inter::Constant',
        default => sub {
            Inter::Constant->new(
                op   => Lexer::Word->False,
                type => Symbols::Type->Bool
            );
        }
    );

    method BUILD ($args) {
        if ( ( scalar keys $args ) == 1 ) {
            $self->type( Symbols::Type->Int );
            $self->op( Lexer::Num->new( value => $args->{int} ) );
        }
    }

    method jumping (Num $t, Num $f) {
        if ( $self == Inter::Constant->True and $t != 0 ) {
            $self->emit( "goto L" . $t );
        }
        elsif ( $self == Inter::Constant->False and $f != 0 ) {
            $self->emit( "goto L" . $f );
        }
    }
}

1;

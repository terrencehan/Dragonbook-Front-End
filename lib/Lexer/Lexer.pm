use MooseX::Declare;

class Lexer::Lexer {

    use lib '../../lib';
    use 5.010;
    use Lexer::Token;
    use Lexer::Word;
    use Lexer::Num;
    use Lexer::Real;
    use Lexer::Tag;
    use Symbols::Type;
    use MooseX::ClassAttribute;

    class_has 'line' => (
        is      => 'rw',
        isa     => 'Num',
        default => 1,
    );

    has 'words' => (
        is      => 'rw',
        isa     => 'HashRef',
        default => sub { {} },
    );
    has 'peek' => (
        is      => 'rw',
        isa     => 'Str',
        default => ' ',
    );

    method _reserve (Lexer::Word $w) {
        $self->words->{ $w->lexeme } = $w;
    }

    method BUILD {
        $self->_reserve(
            Lexer::Word->new( lexeme => "if", tag => Lexer::Tag->IF ) );
        $self->_reserve(
            Lexer::Word->new( lexeme => "else", tag => Lexer::Tag->ELSE ) );
        $self->_reserve(
            Lexer::Word->new( lexeme => "while", tag => Lexer::Tag->WHILE ) );
        $self->_reserve(
            Lexer::Word->new( lexeme => "do", tag => Lexer::Tag->DO ) );
        $self->_reserve(
            Lexer::Word->new( lexeme => "break", tag => Lexer::Tag->BREAK ) );

        for (
            Lexer::Word->True,   Lexer::Word->False,  Symbols::Type->Int,
            Symbols::Type->Bool, Symbols::Type->Char, Symbols::Type->Float
          )
        {
            $self->_reserve($_);
        }
    }

    method _readch {
        shift;       #self;
        if (@_) {
            $self->_readch();
            if ( $self->peek ne shift ) { return 0; }
            $self->peek(' ');
            return 1;
        }
        else {       #TODO add exception handler
            my $c = getc;
            if ($c) {
                $self->peek($c);
            }
            else {
                #occure EOF
            }
        }
    }

    method scan {       #TODO add exception handler
        for ( ; ; $self->_readch() ) {
            if ( $self->peek eq ' ' or $self->peek eq "\t" ) { next; }
            elsif ( $self->peek eq "\n" ) {
                Lexer::Lexer->line( Lexer::Lexer->line + 1 );
            }
            else { last; }
        }
        given ( $self->peek ) {
            when ('&') {
                if ( $self->_readch('&') ) { return Lexer::Word->and; }
                else { return Lexer::Token->new( tag => ord '&' ); }
            }
            when ('|') {
                if ( $self->_readch('|') ) { return Lexer::Word->or; }
                else { return Lexer::Token->new( tag => ord '|' ); }
            }
            when ('=') {
                if ( $self->_readch('=') ) { return Lexer::Word->eq; }
                else { return Lexer::Token->new( tag => ord '=' ); }
            }
            when ('!') {
                if ( $self->_readch('=') ) { return Lexer::Word->ne; }
                else { return Lexer::Token->new( tag => ord '!' ); }
            }
            when ('<') {
                if ( $self->_readch('=') ) { return Lexer::Word->le; }
                else { return Lexer::Token->new( tag => ord '<' ); }
            }
            when ('>') {
                if ( $self->_readch('=') ) { return Lexer::Word->ge; }
                else { return Lexer::Token->new( tag => ord '>' ); }
            }
        }    #end of given

        if ( $self->peek =~ /[0-9]/ ) {
            my $v = 0;
            do {
                $v = 10 * $v + $self->peek;
                $self->_readch();
            } while ( $self->peek =~ /[0-9]/ );

            if ( $self->peek ne '.' ) { return Lexer::Num->new( value => $v ) }
            my ( $x, $d ) = ( $v, 10 );
            while (1) {
                $self->_readch();
                if ( $self->peek !~ [ 0 - 9 ] ) { last }
                $x = $x + $self->peek / $d;
                $d *= 10;
            }
            return Lexer::Real->new( value => $x );
        }
        if ( $self->peek =~ /[a-zA-Z]/ ) {
            my $b = "";
            do {
                $b .= $self->peek;
                $self->_readch();
            } while ( $self->peek =~ /[a-zA-Z]/ );
            my $w = $self->words->{$b};
            if ($w) { return $w; }
            $w = Lexer::Word->new( lexeme => $b, tag => Lexer::Tag->ID );
            $self->words->{$b} = $w;
            return $w;
        }
        my $tok = Lexer::Token->new( tag => (ord $self->peek) );
        $self->peek(' ');
        return $tok;
    }

}

1;

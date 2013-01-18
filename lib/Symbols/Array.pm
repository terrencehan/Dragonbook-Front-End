use MooseX::Declare;
class Symbols::Array extends Symbols::Type {
    use lib '../';
    use Symbols::Type;

    #--BUILD (of => Symbols::Type, size => Num)

    has 'of' => (
        is  => 'rw',
        isa => 'Symbols::Type',
    );

    has 'size' => (
        is      => 'rw',
        isa     => 'Int',
        default => 0,
    );

    method BUILD ($args) {
        $self->lexeme('[]');
        $self->tag( Lexer::Tag->INDEX );
        $self->width( $args->{size} * $args->{of}->width );
    }

    method to_string {
        return '[' . $self->size . ']' . $self->of->to_string;
    }
}

1;

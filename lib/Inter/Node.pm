use MooseX::Declare;
class Inter::Node {

    #BUILD {lexline=> Num, labels=> Num}
    use lib '../';
    use 5.010;
    use Moose;
    use MooseX::ClassAttribute;
    use Lexer::Lexer;

    has 'lexline' => (
        is      => 'rw',
        isa     => 'Num',
        default => sub { Lexer::Lexer->line },
    );

    class_has 'labels' => (
        is      => 'rw',
        isa     => 'Num',
        default => 0,
    );

    method newlebel {
        return Inter::Node->labels( Inter::Node->labels + 1 );
    }

    method error (Str $s) {
        die 'near line' . $self->lexline . ': ' . $s;
    }

    method emitlabel (Num $i) { print "L" . $i . ":"; }

    method emit (Str $s) { say "\t" . $s; }
}

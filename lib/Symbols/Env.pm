use MooseX::Declare;
class Symbols::Env {

    #--BUILD(prev=>Symbols::Env)
    use lib '../';
    use Lexer::Token;
    use Inter::Id;

    has 'table' => (
        is      => 'rw',         #should be private
        isa     => 'HashRef',
        default => sub { {} },
    );

    has 'prev' => (
        is  => 'rw',             #should be protected
        isa => 'Symbols::Env',
    );

    method put (Lexer::Token $w, Inter::Id $i) {
        $self->table->{$w} = $i;
    }

    method get (Lexer::Token $w) {
        for ( my $e = $self ; defined $e ; $e = $e->prev ) {
            my $found = $e->table->{$w};
            return $found if ($found);
        }
        return undef;
    }
}

1;

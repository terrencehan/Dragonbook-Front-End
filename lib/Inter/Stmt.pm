use MooseX::Declare;
class Inter::Stmt extends Inter::Node {

    #-- BUILD ()
    use lib '../';
    use MooseX::ClassAttribute;

    class_has 'Null' => (    #represents an empty sequence of statements
        is      => 'rw',
        isa     => 'Inter::Stmt',
        default => sub { Inter::Stmt->new; },
    );

    class_has 'Enclosing' => (    # used for break stmts
        is      => 'rw',
        isa     => 'Inter::Stmt',
        default => sub { Inter::Stmt->Null; },
    );

    has after => (                #saves label after
        is      => 'rw',
        isa     => 'Num',
        default => 0,
    );

    method gen (Num $b, Num $a) { }  # called with labels begin and after
      # b marks the beginning of the code for this statement and a marks the first instruction after the code for this statement
}

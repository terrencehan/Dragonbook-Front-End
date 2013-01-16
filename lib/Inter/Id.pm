use MooseX::Declare;

class Inter::Id extends Inter::Expr {

    #--BUILD {op=> Lexer::Token, type => Symbols::Type, offset => Int}
    use lib '../';

    has 'offset' => (    #relative address
        is  => 'rw',
        isa => 'Inter::Id',
    );
}

1;

use MooseX::Declare;

class Inter::Id extends Inter::Expr {

#inhert the default implementations of 'gen' and 'reduce' in class 'Inter::Expr'

    #--BUILD {op=> Lexer::Word, type => Symbols::Type, offset => Int}
    use lib '../';

    has 'offset' => (    #relative address
        is  => 'rw',
        isa => 'Num',
    );
}

1;

use MooseX::Declare;
use 5.010;

class Parser::Parser {
    use Moose::Util::TypeConstraints;
    use lib '../';
    use Lexer::Lexer;
    use Lexer::Tag;
    use Lexer::Token;
    use Symbols::Array;
    use Symbols::Type;
    use Symbols::Env;
    use Inter::Id;
    use Inter::Break;
    use Inter::Access;
    use Inter::Stmt;
    use Inter::Arith;
    use Inter::While;
    use Inter::Do;
    use Inter::Seq;
    use Inter::Rel;
    use Inter::If;
    use Inter::Constant;
    use Inter::Unary;
    use Inter::Set;
    use Inter::SetElem;
    use Inter::Or;

    has 'lex' => (
        is      => 'rw',
        isa     => 'Lexer::Lexer',
        default => sub { Lexer::Lexer->new; }
    );

    has 'look' => (    #lookahead tagen
        is  => 'rw',
        isa => 'Lexer::Token',
    );

    has 'top' => (     #current or top symbol table
        is      => 'rw',
        isa     => 'Symbols::Env',
        default => sub { Symbols::Env->new; }
    );

    has 'used' => (    #storage used for declarations
        is      => 'rw',
        isa     => 'Num',
        default => 0,
    );

    method BUILD {
                       #$self->move();
    }

    method run {
        $self->move();
    }

    method move {
        my $look = $self->lex->scan;
        if ($look) {
            $self->look($look);
        }
        else {
        }
    }

    method error (Str $s) {
        die 'near line ' . $self->lex->line . ": " . $s;
    }

    method match (Num|Str $t) {
        match_on_type $t => (
            Num => sub { },
            Str => sub {
                $t = ord $t;
            },
        );
        if ( $self->look->tag == $t ) {
            $self->move();
        }
        else {
            $self->error("syntax error");
        }
    }

    method program {    # program -> block
        my $s     = $self->block;    #Inter::Stmt
        my $begin = $s->newlabel;
        my $after = $s->newlabel;
        $s->emitlabel($begin);
        $s->gen( $begin, $after );
        $s->emitlabel($after);
    }

    method block {                      #block -> { decls stmts }
        $self->match('{');
        my $savedEnv = $self->top;    #Symbols::Env
        $self->top( Symbols::Env->new( prev => $self->top ) );
        $self->decls();
        my $s = $self->stmts();       #Inter::Stmt
        $self->match('}');
        $self->top($savedEnv);
        $s;
    }

    method decls {
        while ( $self->look->tag == Lexer::Tag->BASIC ) {    # D -> type ID
            my $p   = $self->type();                         #Symbols::Type
            my $tok = $self->look;
            $self->match( Lexer::Tag->ID );
            $self->match(';');
            my $id =
              Inter::Id->new( op => $tok, type => $p, offset => $self->used );
            $self->top->put( $tok, $id );
            $self->used( $self->used + $p->width );
        }
    }

    method type {
        my $p = $self
          ->look;    #Symbols::Type expect $self->look->tag == Lexer::Tag->BASIC
        $self->match( Lexer::Tag->BASIC );
        if ( $self->look->tag != ord('[') ) { return $p; }    #T -> basic
        else { return $self->dims($p); }                      #return array
    }

    method dims (Symbols::Type $p) {
        $self->match('[');
        my $tok = $self->look;
        $self->match( Lexer::Tag->NUM );
        $self->match(']');
        if ( $self->look->tag == ord('[') ) {
            $p = $self->dims($p);
        }
        Symbols::Array->new( size => $tok->value, of => $p );
    }

    method stmts {
        if ( $self->look->tag == ord('}') ) {
            Inter::Stmt->Null;
        }
        else {
            Inter::Seq->new( stmt1 => $self->stmt(), stmt2 => $self->stmts() );
        }
    }

    method stmt {
        my $x;     #Inter::Expr
        my ( $s, $s1, $s2 );    #Inter::Stmt
        my $savedStmt;          #Inter::Stmt  save enclosing loop for breaks
        given ( $self->look->tag ) {
            when ( ord ';' ) {
                $self->move();
                Inter::Stmt->Null;
            }
            when ( Lexer::Tag->IF . "" ) {
                $self->match( Lexer::Tag->IF );
                $self->match('(');
                $x = $self->bool();
                $self->match(')');

                $s1 = $self->stmt();
                if ( $self->look->tag != Lexer::Tag->ELSE ) {
                    Inter::If->new( expr => $x, stmt => $s1 );
                }
                else {
                    $self->match( Lexer::Tag->ELSE );
                    $s2 = $self->stmt();
                    Inter::If->new( expr => $x, stmt1 => $s1, stmt2 => $s2 );
                }
            }
            when ( Lexer::Tag->WHILE . "" ) {
                my $whilenode = Inter::While->new;
                $savedStmt = Inter::Stmt->Enclosing;
                Inter::Stmt->Enclosing($whilenode);

                $self->match( Lexer::Tag->WHILE );
                $self->match('(');
                $x = $self->bool();
                $self->match(')');

                $s1 = $self->stmt();
                $whilenode->init( $x, $s1 );
                Inter::Stmt->Enclosing($savedStmt);
                return $whilenode; #TODO why we must return $whilenode explicitly
            }
            when ( Lexer::Tag->DO . "" ) {
                my $donode = Inter::Do->new;
                $savedStmt = Inter::Stmt->Enclosing;
                Inter::Stmt->Enclosing($donode);
                $self->match( Lexer::Tag->DO );
                $s1 = $self->stmt();

                $self->match( Lexer::Tag->WHILE );
                $self->match('(');
                $x = $self->bool();
                $self->match(')');

                $donode->init( $s1, $x );
                Inter::Stmt->Enclosing($savedStmt);
                return $donode;

            }
            when ( Lexer::Tag->BREAK . "" ) {
                $self->match( Lexer::Tag->BREAK );
                $self->match(';');
                return Inter::Break->new;
            }
            when ( ord '{' ) {
                $self->block();
            }
            default {
                $self->assign();
            }
        }
    }

    method assign {
        my $stmt;    #Inter::Stmt
        my $t = $self->look;    #Lexer::Token
        $self->match( Lexer::Tag->ID );
        my $id = $self->top->get($t);    #Inter::Id
        $self->error( $t->to_string . " undeclared" ) if not defined $id;
        if ( $self->look->tag == ord('=') ) {    # S -> id = E
            $self->move();
            $stmt = Inter::Set->new( id => $id, expr => $self->bool() );
        }
        else {
            my $x = $self->offset($id);          #Inter::Access
            $self->match('=');
            $stmt = Inter::SetElem->new( access => $x, expr => $self->bool );
        }
        $self->match(';');
        $stmt;
    }

    method bool {
        my $x = $self->join();                   # Inter::Expr
        while ( $self->look->tag == Lexer::Tag->OR ) {
            my $tok = $self->look;
            $self->move();
            $x =
              Inter::Or->new( op => $tok, expr1 => $x, expr2 => $self->join() );
        }
        $x;
    }

    method join {
        my $x = $self->equality();               # Inter::Expr
        while ( $self->look->tag == Lexer::Tag->AND ) {
            my $tok = $self->look;
            $self->move();
            $x = Inter::And->new(
                op    => $tok,
                expr1 => $x,
                expr2 => $self->equality()
            );
        }
        $x;
    }

    method equality {
        my $x = $self->rel();    # Inter::Expr
        while ($self->look->tag == Lexer::Tag->EQ
            or $self->look->tag == Lexer::Tag->NE )
        {
            my $tok = $self->look;
            $self->move();
            $x =
              Inter::Rel->new( op => $tok, expr1 => $x, expr2 => $self->rel() );
        }
        $x;
    }

    method rel {
        my $x = $self->expr();    # Inter::Expr
        given ( $self->look->tag ) {
            when ( [ ord('<'), Lexer::Tag->LE, Lexer::Tag->GE, ord('>') ] ) {
                my $tok = $self->look;
                $self->move();
                $x = Inter::Rel->new(
                    op    => $tok,
                    expr1 => $x,
                    expr2 => $self->rel()
                );

            }
            default {
                $x;
            }
        }
    }

    method expr {
        my $x = $self->term();    # Inter::Expr
        while ( $self->look->tag == ord('+') or $self->look->tag == ord('-') ) {
            my $tok = $self->look;
            $self->move();
            $x = Inter::Arith->new(
                op    => $tok,
                expr1 => $x,
                expr2 => $self->term()
            );

        }
        $x;

    }

    method term {
        my $x = $self->unary();    # Inter::Expr
        while ( $self->look->tag == ord('*') or $self->look->tag == ord('/') ) {
            my $tok = $self->look;
            $self->move();
            $x = Inter::Arith->new(
                op    => $tok,
                expr1 => $x,
                expr2 => $self->unary()
            );

        }
        $x;

    }

    method unary {
        if ( $self->look->tag == ord('-') ) {
            $self->move();
            Inter::Unary->new(
                op   => Lexer::Word->minux,
                expr => $self->unary()
            );
        }
        elsif ( $self->look->tag == ord('!') ) {
            my $tok = $self->look;
            $self->move();
            Inter::Not->new( op => $tok, expr => $self->unary() );
        }
        else {
            $self->factor();
        }
    }

    method factor {
        my $x;      #Inter::Expr
        given ( $self->look->tag ) {
            when ( ord('(') ) {
                $self->move();
                $x = $self->bool();
                $self->match(')');
                $x;
            }
            when ( Lexer::Tag->NUM . "" ) {
                $x = Inter::Constant->new(
                    op   => $self->look,
                    type => Symbols::Type->Int
                );
                $self->move();
                $x;
            }
            when ( Lexer::Tag->REAL . "" ) {
                $x = Inter::Constant->new(
                    op   => $self->look,
                    type => Symbols::Type->Float
                );
                $self->move();
                $x;
            }
            when ( Lexer::Tag->TRUE . "" ) {
                $x = Inter::Constant->True;
                $self->move();
                $x;
            }
            when ( Lexer::Tag->FALSE . "" ) {
                $x = Inter::Constant->False;
                $self->move();
                $x;
            }
            when ( Lexer::Tag->ID . "" ) {
                my $s  = $self->look->to_string;
                my $id = $self->top->get( $self->look );
                $self->error( $self->look->to_string . " undeclared" )
                  if ( not defined $id );
                $self->move();
                if ( $self->look->tag != ord('[') ) {
                    return $id;
                }
                else {
                    $self->offset($id);
                }
            }
        }
    }

    method offset (Inter::Id $a) {    # I -> [E] | [E] I
        my ( $i, $w, $t1, $t2, $loc );    #Inter::Expr    inherit id
        my $type = $a->type;
        $self->match('[');                #first index, I -> [E]
        $i = $self->bool();
        $self->match(']');

        $type = $type->of;
        $w    = Inter::Constant->new( int => $type->width );
        $t1   = Inter::Arith->new(
            op    => Lexer::Token->new( tag => ord('*') ),
            expr1 => $i,
            expr2 => $w
        );
        $loc = $t1;
        while ( $self->look->tag == ord('[') ) {    #muti-dimensional I -> [E] I
            $self->match('[');
            $i = $self->bool();
            $self->match(']');
            $type = $type->of;
            $w    = Inter::Constant->new( int => $type->width );
            $t1   = Inter::Arith->new(
                op    => Lexer::Token->new( tag => ord('*') ),
                expr1 => $i,
                expr2 => $w
            );
            $t2 = Inter::Arith->new(
                op    => Lexer::Token->new( tag => ord('+') ),
                expr1 => $loc,
                expr2 => $t1
            );
            $loc = $t2;
        }
        Inter::Access->new( array => $a, index => $loc, type => $type );
    }

}

1;

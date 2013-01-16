use MooseX::Declare;

class Lexer::Tag {

    use MooseX::ClassAttribute;

    my @name = qw(
      AND   BASIC   BREAK   DO
      ELSE  EQ      FALSE   GE
      ID    IF      INDEX   LE
      MINUS NE      NUM     OR
      REAL  TEMP    TRUE    WHILE
    );
    my $number = 256;
    for (@name) {
        class_has $_ => (
            is      => 'ro',
            isa     => 'Num',
            default => $number++
        );
    }
}

1;

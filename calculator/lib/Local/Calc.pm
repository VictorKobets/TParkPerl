package Local::Calc;

use 5.010;
use strict;
use warnings;
BEGIN{
    if ($] < 5.018) {
        package experimental;
        use warnings::register;
    }
}
no warnings 'experimental';

use Exporter 'import';
our @EXPORT_OK = qw(tokenize rpn evaluate);

# description of operators
my $operators = {
    'U-' => {
        'priority' => 4,
        'association' => 'right',
        'arguments' => 1,
        'action' => sub { -$_[0] }
    },
    'U+' => {
        'priority' => 4,
        'association' => 'right',
        'arguments' => 1,
        'action' => sub { $_[0] }
    },
    '^' => {
        'priority' => 3,
        'association' => 'right',
        'arguments' => 2,
        'action' => sub { $_[1] ** $_[0] }
    },
    '*' => {
        'priority' => 2,
        'association' => 'left',
        'arguments' => 2,
        'action' => sub { $_[1] * $_[0] }
    },
    '/' => {
        'priority' => 2,
        'association' => 'left',
        'arguments' => 2,
        'action' => sub { $_[1] / $_[0] }
    },
    '-' => {
        'priority' => 1,
        'association' => 'left',
        'arguments' => 2,
        'action' => sub { $_[1] - $_[0] }
    },
    '+' => {
        'priority' => 1,
        'association' => 'left',
        'arguments' => 2,
        'action' => sub { $_[1] + $_[0] }
    }
};

=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, состоящий из отдельных токенов.
Токен - это отдельная логическая часть выражения: число, скобка или арифметическая операция.
В случае ошибки в выражении функция должна вызывать die с сообщением об ошибке.

Знаки '-' и '+' в первой позиции, или после другой арифметической операции стоит воспринимать
как унарные и можно записывать как "U-" и "U+".

Стоит заметить, что после унарного оператора нельзя использовать бинарные операторы.
Например последовательность 1 + - / 2 невалидна. Бинарный оператор / идёт после использования унарного "-".

=cut

sub tokenize {
    chomp(my $expr = shift);
    my @result;
    # split by operators and whitespace
    my @tokens = split m{((?<!e)[-+^*/)(\s])}, $expr;
    # parsing
    my $last = 'START';
    for (@tokens) {
        # skip blank and whitespace
        next if /^\s*$/;
        # for numbers
        if ( /\d/ && $last =~ /[^\d]/) {
            ( /^\d*\.?\d+(?:e[-+]?\d+)?$/ ) ? push @result, $_ + 0 : die "Bad: '$_'";
        }
        # for 'U+' and 'U-'
        elsif ( /[+-]/ ) {
            ( $last =~ /[)\d]/ ) ? push @result, $_ : push @result, "U".$_;
        }
        # for other operators
        elsif ( /[*\/^]/ ) {
            ( $last =~ /[)\d]/ ) ? push @result, $_ : die "Bad: '$last $_'";
        }
        # for brackets
        elsif ( /\(/ ) {
            ( $last =~ /[-+*\/^]|START/ ) ? push @result, $_ : die "Bad: '$last $_'";
        }
        elsif ( /\)/ ) {
            ( $last =~ /\d/ ) ? push @result, $_ : die "Bad: '$last $_'";
        }
        # for exeption chars
        else {
            die "Bad: '$_'";
        }
        # remember the last one
        $last = $_;
    }
    # check last char
    ( $last =~ /[\d)]/ ) ? return \@result : die "Bad: $last";
}

=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, содержащий обратную польскую нотацию.
Один элемент массива - это число или арифметическая операция.
В случае ошибки функция должна вызывать die с сообщением об ошибке.

=cut

sub rpn {
    my $expr = shift;
    my $tokens = tokenize($expr);
    my @queue;
    # translation into reverse polish notation
    my @stack;
    for (@{$tokens}) {
        # if the token is an operator
        if ( exists $operators->{$_} ) {
            while (my $last = pop @stack) {
                # while at the top of the stack there is a token operator $last, as well as the operator $char
                # left-associative and its priority is less or the same as the $last operator, or the char 
                # operator is right-associative and its priority is less than that of the $last operator
                if (
                    exists $operators->{$last}
                    && $operators->{$_}->{'association'} eq 'left'
                    && $operators->{$_}->{'priority'} <= $operators->{$last}->{'priority'}
                ) {
                    push @queue, $last;
                } else {
                    push @stack, $last;
                    last;
                }
            }
            push @stack, $_;
        }
        # if the token is a left parenthesis, then put it on the stack
        elsif ( /\(/ ) {
            push @stack, $_;
        }
        # if the token is a right parenthesis, then put it on the stack
        elsif ( /\)/ ) {
            # before appearing on the top of the token stack "left round bracket"
            # move operators from the stack to the output queue
            while (my $last = pop @stack) {
                ($last eq '(') ? last : push @queue, $last;
            }
        }
        # if the token is a number, then add it to the output queue
        else {
            push @queue, $_;
        }
    }
    # when there are no tokens left on the input
    # if tokens remain on the stack
    while (my $last = pop (@stack)) {
        push @queue, $last;
    }
    return \@queue;
}

=head1 DESCRIPTION

Эта функция должна принять на вход ссылку на массив, который представляет из себя обратную польскую нотацию,
а на выходе вернуть вычисленное выражение.

=cut

sub evaluate {
    my $rpn = shift;
    # solve
    my @stack;
    my @result;
    for (@{$rpn}) {
        if ( !exists $operators->{$_} ) {
            push @result, $_;
        }
        else {
            if ( $operators->{$_}->{'arguments'} == 1 ) {
                push @result, $operators->{$_}->{'action'}->( pop @result );
            } else {
                push @result, $operators->{$_}->{'action'}->( pop @result, pop @result );
            }
            pop @stack;
        }
    }
    return $result[0];
}

1;

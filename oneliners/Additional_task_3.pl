#!/usr/bin/perl

# скрипт - найти все простые числа в диапазоне от 1..N(N приходит как аргумент в программу)
use strict;

my $n = $ARGV[0];
if (scalar @ARGV > 1) { print "Ошибка! Вводите один аргумент!\n"; exit }
unless (defined $n) { print "Oшибка! Вы не ввели аргумент!\n"; exit }
unless ($n =~ /^\d+$|^\d+[.,]\d+$/) { print "Ошибка! Вводите число!\n"; exit }

print "Простые числа от 0 до $n:\n";
for (my $k = 2; $k < $n + 1; $k++) {
    my $is_simple = 1;
    for (my $m = 2; $m < $k; $m++) {
        if ($k % $m == 0) { $is_simple = 0; last }
    }
    if ($is_simple) { print "$k " }
}
print "\n";

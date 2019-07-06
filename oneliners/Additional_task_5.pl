#!/usr/bin/perl

# скрипт - распечатать словами число из аргумента.Поддержать числа до миллиарда
### ATTENTION - поддерживает до триллиона :D
use strict;

sub num_to_word {
    my ($n, $gen) = @_;
    my $num;
    
    if ($n < 20) {
        my @units_teens = qw/
        ноль один два три четыре пять шесть семь восемь 
        девять десять одиннадцать двенадцать тринадцать 
        четырнадцать пятнадцать шестнадцать семнадцать 
        восемнадцать девятнадцать
        /;
        if ($gen == 0) {
            $num = $units_teens[$n];
        } else {
            my @gender = qw/одна две/;
            my @tmp = ($units_teens[0], @gender, @units_teens[3..19]);
            $num = $tmp[$n];
        }
    } elsif ($n < 100) {
        my @tens = qw/_ _ 
        двадцать тридцать сорок пятьдесят шестьдесят 
        семьдесят восемьдесят девяносто
        /;
        $num = $tens[$n / 10];
        if ($n % 10) {
            $num .= ' '.num_to_word($n % 10, $gen);
        }
    } elsif ($n < 1_000) {
        my @hundreds = qw/_ 
        сто двести триста четыреста пятьсот 
        шестьсот семьсот восемьсот девятьсот
        /;
        $num = $hundreds[$n / 100];
        if ($n % 100) {
            $num .= ' '.num_to_word($n % 100, $gen);
        }
    } elsif ($n < 1_000_000) {
        my @thousands = qw/тысяча тысячи тысяч/;
        my $teens = $n % 1_000;
        my $thous = ($n - $teens) / 1_000;
        $_ = ($teens != 0) ? num_to_word($teens, 0) : '';
        if (genus($thous) == 0) {
            $num = num_to_word($thous, 1).' '.$thousands[0].' '.$_;
        } elsif (genus($thous) == 1) {
            $num = num_to_word($thous, 1).' '.$thousands[1].' '.$_;
        } else {
            $num = num_to_word($thous, 0).' '.$thousands[2].' '.$_;
        }
    } elsif ($n < 1_000_000_000) {
        my @millions = qw/миллион миллиона миллионов/;
        my $teens = $n % 1_000_000;
        my $thous = ($n - $teens) / 1_000_000;
        $_ = ($teens != 0) ? num_to_word($teens, 0) : '';
        if (genus($thous) == 0) {
            $num = num_to_word($thous, 0).' '.$millions[0].' '.$_;
        } elsif (genus($thous) == 1) {
            $num = num_to_word($thous, 0).' '.$millions[1].' '.$_;
        } else {
            $num = num_to_word($thous, 0).' '.$millions[2].' '.$_;
        }
    } elsif ($n < 1_000_000_000_000) {
        my @billions = qw/миллиард миллиарда миллиардов/;
        my $teens = $n % 1_000_000_000;
        my $thous = ($n - $teens) / 1_000_000_000;
        $_ = ($teens != 0) ? num_to_word($teens, 0) : '';
        if (genus($thous) == 0) {
            $num = num_to_word($thous, 0).' '.$billions[0].' '.$_;
        } elsif (genus($thous) == 1) {
            $num = num_to_word($thous, 0).' '.$billions[1].' '.$_;
        } else {
            $num = num_to_word($thous, 0).' '.$billions[2].' '.$_;
        }
    }
    return $num;
}

sub genus {
    my $n = $_[0];
    my $class;
    if ($n > 100) {$n %= 100}
    if ($n > 20) {$n %= 10}
    if ($n == 1) {$class = 0}
    elsif ($n == 2 || $n == 3 || $n == 4) {$class = 1}
    else {$class = 2}
    return $class;
}

my $n = $ARGV[0];
if (scalar @ARGV > 1) { print "Ошибка! Вводите один аргумент!\n"; exit }
unless (defined $n) { print "Oшибка! Вы не ввели аргумент!\n"; exit }
unless ($n =~ /^\d+$|^\d+[.,]\d+$/) { print "Ошибка! Вводите число!\n"; exit }

print "Словами число из аргумента:\n";
print num_to_word($n, 0), "\n";

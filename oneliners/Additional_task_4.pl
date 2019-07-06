#!/usr/bin/perl

# скрипт - посчитать сколько осталось секунд до конца часа,дня, недели
use Time::localtime;

my $time = localtime;
($sec, $min, $hour, $wday) = ($time->sec, $time->min, $time->hour, $time->wday);
my $to_hour = 3600 - $sec - $min * 60;
my $to_day = (23 - $hour) * 3600 + $to_hour;
my $to_week = (7 - $wday) * 86400 + $to_day;

printf("\e[5;31mТекущее время: %02d:%02d:%02d\e[0m
До конца часа осталось $to_hour сек.
До конца дня осталось $to_day сек.
До конца недели осталось $to_week сек.\n", $hour, $min, $sec);

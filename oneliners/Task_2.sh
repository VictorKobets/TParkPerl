#!/usr/bin/perl

# однострочник - принять на вход вывод ls -lA, вывести top 5 файлов по размеру
ls -lA | perl -n -e '@F=split(" ",$_,9);if(scalar @F==9){$hash{$F[8]}=$F[4]}}{@F=sort{$hash{$b}<=>$hash{$a}}keys %hash;for(@F[0..4]){print $_}'

ls -lA | perl -n -E 'if(/^[^\d]+\d+[^\d]+(\d+).+\d+\s(.+)$/){$hash{$2}=$1}}{@F=sort{$hash{$b}<=>$hash{$a}}keys %hash;for(@F[0..4]){say $_}'

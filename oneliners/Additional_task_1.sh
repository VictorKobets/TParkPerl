#!/usr/bin/perl

# однострочник - посчитать уникальные символы в текстовомфайле (вывести количество)
perl -F -na -E 'for(@F){unless(!exists($hash{$_})&&/[\0\a\b\t\n\v\f\r]/){$hash{$_}=1}}}{say scalar keys %hash;' example.txt

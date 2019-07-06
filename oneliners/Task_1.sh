#!/usr/bin/perl

# однострочник - вывести количество пустых строк в файле и убрать их из файла (-i)
perl -i -n -E 'if(/\S/){print}else{++$n}}{say $n || 0;' example.txt

#!/usr/bin/perl

# Скрипт - принять на вход вывод предыдущего однострочника.
# Раскрасить строки (ANSI Escape Sequences):
for my $file (<>) {
    chomp($file);
    my $size = -s("$file");
    if ($size < 1_048_576) {
        print "\e[7;32m$file\e[0m\n";
    } elsif ($size >= 1_048_576 && $size < 104_857_600) {
        print "\e[7;33m$file\e[0m\n";
    } else {
        print "\e[7;31m$file\e[0m\n";
    }
}

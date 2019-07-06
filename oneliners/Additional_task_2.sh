#!/usr/bin/perl

# однострочник - вывести список пользователей, у которыхшелл - bash (смотреть файл /etc/passwd)
less /etc/passwd | perl -n -E 'if(m|/bin/bash|){/([^\:]+)/;say $1}'

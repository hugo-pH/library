#!/usr/bin/perl -w
use DBI;
use DBD::mysql;
use strict;
use utf8;
use Unicode::Normalize;
use Text::Unaccent;
my $charset= "UTF-8";
my @keys = ();
my $file = "/home/biblioteca/usuario.csv";
open (FILE, $file) or die("Can't open $file: $!\n");
my @lines = <FILE>;
close FILE;
for my $line(@lines) {
 	chomp $line;
    if ($line=~ /^nombre/)  {
	@keys = split (" ", $line);
    next;
}

    my @data = split ("\t", $line);
   for my $datum (@data){
	$datum =~ s/^\s+|\s+$//g;#remove leading and ending whitespaces.
       	$datum =unac_string($charset, $datum);
} 
    my $name_accent = $data[0];
    my $name=unac_string($charset, $name_accent); ##Quita las tildes (funciona con el módulo Text::Unaccent)
    my $mail = $data[1];
    my $tlf = $data[2];
    my $place = $data[3];
    my $keys = join (", ",@keys);
 #  print "$name, $mail;\n";
my $ds = "DBI:mysql:library:localhost";
my $user_sql;
my $password;
my $dbh = DBI->connect($ds. ";mysql_read_default_file=/home/.my.cnf",
                $user_sql, $password) || die "Can't connect!";
   my $sth=$dbh->prepare("INSERT INTO usuario (user_id, nombre, mail, tlf, localizacion) VALUES ('', ?, ?, ?, ?)");
   $sth->execute($name, $mail, $tlf, $place);
   $dbh->disconnect;
}


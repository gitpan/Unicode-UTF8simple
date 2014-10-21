#!/usr/bin/perl -w
# vim: set sw=4 ts=4 si et:
# Copyright: GPL, Author: Guido Socher
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

BEGIN { $| = 1; print "1..8\n"; }
END {print "nok ok 1\n" unless $loaded;}
use Unicode::UTF8simple;
no locale;
$loaded = 1;
print "ok 1\n";

sub print_string_as_hex($){
    my $str=shift;
    for my $c (unpack("C*",$str)){
        printf("0x%x,",$c);
    }
    print "\n";
}

my $i=2;
my $uref = new Unicode::UTF8simple;
my $u=$uref->toUTF8("iso-8859-1","sch�n");
if ($u eq 'schön'){
	print "ok $i\n";
}else{
	print "nok $i \[$u\]\n";
}
$i++;
#
my $s=$uref->fromUTF8("iso-8859-1",$u);
if ($s eq 'sch�n'){
	print "ok $i\n";
}else{
	print "nok $i \[$s\]\n";
}
$i++;
#
$u=$uref->toUTF8("koi8-r",chr(0xc7));
if ($u eq 'г'){
	print "ok $i\n";
}else{
	print "nok $i \[$u\]\n";
}
$i++;

$u=$uref->toUTF8("koi8-r",pack("C8",(225,215,199,213,211,212,32,50)));
#$u=$uref->toUTF8("koi8-r","������ 2");
# should be  readable as �вг��� 2 (but contains invisible control char!)
# it really is Август 2
if ($u eq pack("C14",0xd0,0x90,0xd0,0xb2,0xd0,0xb3,0xd1,0x83,0xd1,0x81,0xd1,0x82,0x20,0x32)){
	print "ok $i\n";
}else{
	print "nok $i \[$u\]\n";
}
$i++;

$u=$uref->fromUTF8("koi8-r",pack("C14",0xd0,0x90,0xd0,0xb2,0xd0,0xb3,0xd1,0x83,0xd1,0x81,0xd1,0x82,0x20,0x32));
if ($u eq pack("C8",(225,215,199,213,211,212,32,50))){
	print "ok $i\n";
}else{
	print "nok $i \[$u\]\n";
}
$i++;

$u=$uref->toUTF8("gb2312",'s ��־, ����');
if ($u eq 's 杂志, 中文'){
	print "ok $i\n";
}else{
	print "nok $i \[$u\]\n";
}
$i++;

$u=$uref->fromUTF8("gb2312",'s 杂志, 中文');
if ($u eq 's ��־, ����'){
	print "ok $i\n";
}else{
	print "nok $i \[$u\]\n";
}
$i++;

print "   supported encodings:\n";
for ($uref->enclist()){
    print "    $_\n";
}
$i++;

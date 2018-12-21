#!/usr/bin/perl
#======================================================================
# Auteur : sgaudart@capensis.fr
# Date   : 03/12/2018
# But    : this script can change requirements.yml with mode :
#          - ssh
#          - https
#          - https + login + password
#
# INPUT :
#          [--mode <ssh|https> --login <login_only_with_https>] --password <pass_only_with_https>
# OUTPUT :
#          show content of requirements.yml with only https mode or ssh mode (for GIT)
#======================================================================

use strict;
use Getopt::Long;

my $mode=""; # ssh ou https
my $login="";
my $pass="";
my $file="";
my $line;
my $skip=""; # if you want to skip several line in requirement.yml
my $url="";
my $prefix="";
my ($verbose, $help, $askpassword);

GetOptions (
"mode=s" => \$mode, # string
"login=s" => \$login, # string
"password=s" => \$pass, # string
"skip=s" => \$skip, # string
"verbose" => \$verbose, # flag
"ask-password" => \$askpassword, # flag
"help" => \$help) # flag
or die("Error in command line arguments\n");

###############################
# HELP
###############################

if ( ($help) || (($mode ne "ssh") && ($mode ne "https")) || ($ARGV[0] eq "") )
{
  print"./change_requirements.pl --mode <ssh|https> [--login <login> --password <pass> or --ask-password if https] requirements.yml
                         [--verbose] [--skip]\n";
  exit;
}

print "premier argument : $ARGV[0]\n" if $verbose;
$file = $ARGV[0];

if ($askpassword)
{
  print "Your password : ";
  $pass = <STDIN>;
  chomp $pass;
}

open (REQUIREMENTFD, "$file") or die "Can't open requirements.yml : $file\n" ; # reading
while (<REQUIREMENTFD>)
{
   $line=$_;
   chomp($line); # delete the carriage return

   if ( ($skip ne "") && ($line =~/$skip/) ) { print "$line\n"; next; }

   if ($mode eq "ssh")
   {
       if ($line =~ /^(.*) https:\/\/(.*)$/)
       {
          $prefix=$1;
          $url=$2;
          $url =~ s/\//:/;
          print "$prefix git\@$url\n";
       }
      else { print "$line\n"; }
   }

   if ($mode eq "https")
   {
      if ( ($line =~ /^(.*) git\@(.*)$/) || ($line =~ /^(.*) https:\/\/(.*)$/) )
      {
         $prefix=$1;
         $url=$2;
         $url =~ s/:/\//;
         if (($login ne "") && ($pass eq "")) { print "$prefix https://$login\@$url\n"; }
         elsif (($login ne "") && ($pass ne "")) { print "$prefix https://$login:$pass\@$url\n"; }
         else { print "$prefix https:\/\/$url\n"; }
      }
      else { print "$line\n"; }
   }

}

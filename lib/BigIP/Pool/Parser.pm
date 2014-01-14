package BigIP::Pool::Parser;

#
# BIG-IP Pool Parser.
#

use strict;
use warnings;

use lib '/nas/home/minjzhang/ops/util/lib';
use lib '/nas/reg/lib/perl';

use Readonly;

BEGIN {
  use Exporter();
  our ( $VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS );

  $VERSION = do { my @r = (q$Revision: 1.1 $ =~ /\d+/g); sprintf "%d."."%02d" x $#r, @r };

  @ISA          = qw( Exporter );
  @EXPORT       = qw();
  @EXPORT_OK    = qw(
                      &parse_pool
                    );
  %EXPORT_TAGS  = ();
}

our @EXPORT_OK;

#
# Parse the pool properties from configurations file.
#
sub parse_pool {
    my ( $pool_config_file ) = @_;
    open POOL_CONFIG_FH, "<$pool_config_file" or die $!;

    my $pool_name = qw{};
    my $in_members_section = 0;
    my @pool_members;

    while ( my $line = <POOL_CONFIG_FH> ) {
        if ( $in_members_section ) {
            if ( $line =~ /^\s*}\s*$/ ) {
                $in_members_section = 0;
                next;
            }
            $line =~ s/^\s*(.*) {.*$/$1/;
            chomp $line;
            push @pool_members, $line;
        }
        if ( $line =~ /^\s*members {/ ) {
            $in_members_section = 1;
            next;
        }
        if ( $line =~ m/^(?:ltm)?\s*pool\s+/ ) {
            $pool_name = $line;
            $pool_name =~ s/^(?:ltm)?\s*pool\s+(\S+)\s{\s*$/$1/;
        }
    }
    my %pool = (
        'members'   => join ",", sort( @pool_members ),
    );
    return ( $pool_name, \%pool );
}

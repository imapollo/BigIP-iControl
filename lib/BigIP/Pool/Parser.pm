package BigIP::Pool::Parser;

#
# BIG-IP Pool Parser.
#

use strict;
use warnings;

use lib '/nas/reg/lib/perl';
use lib '/nas/home/minjzhang/ops/util/lib';

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
    while ( my $line = <POOL_CONFIG_FH> ) {
        if ( $line =~ m/^pool\s+/ ) {
            $pool_name = $line;
            $pool_name =~ s/^pool\s+(\S+)\s{\s*$/$1/;
        }
    }
    my %pool = (
    );
    return ( $pool_name, \%pool );
}

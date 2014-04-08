package Plack::Middleware::Auth::CAS;
use Modern::Perl;
use parent qw( Plack::Middleware );
use Plack::Util::Accessor qw( base login logout );
use Plack::Request;

# ABSTRACT: PSGI CAS Authentication Middleware
our $VERSION = '0.0';

sub prepare_app {
    # in developpers we trust
}

sub call {

}



1;

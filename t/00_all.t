#! /usr/bin/perl
use Modern::Perl;
use YAML;
use Plack::Test; 
use Plack::Builder;
use HTTP::Request::Common;
use IO::All;

my $app = builder {
    # enable qw( Auth::CAS base https://cas.unistra.fr );
    sub {
        [ 200
        , ["Content-Type", "text/plain"]
        , ["You found it, Arthur!" ] ]
    }
};

test_psgi $app, sub {
    my $cb = shift;
    my $res = $cb->(GET '/');
    io('/tmp/debug-struct') < YAML::Dump $res;
    1
}

#! /usr/bin/perl
use Modern::Perl;
# use YAML;
# use IO::All;

use Plack::Builder; 
use Plack::Test; 
use HTTP::Request::Common;
use Test::More;

# Inspired by: 
    # Plack::Middleware::Auth::Htpasswd 
    # Plack::Middleware::Auth::CAS
    # Plack::Middleware::Auth::Form
    # Plack::Middleware::Auth::Basic 

my $app = builder { 

    enable
    qw( Plack::Middleware::Auth::CAS
        server  https://cas.unistra.fr
        service http://filsender.unistra.fr
        logout /logout );

    sub {
        [ 201
        , ["Content-Type", "text/plain"]
        , ["hello Test::More"] ]
    } 

};

my $test = Plack::Test->create($app);
my $res = $test->request(GET "/");

is
( ($res->code)
, 302
, "result content is what was passed" );

done_testing;

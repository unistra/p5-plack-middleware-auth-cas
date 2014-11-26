package Plack::Middleware::Auth::CAS;
use Modern::Perl;
use parent qw( Plack::Middleware );
use Plack::Util::Accessor qw( server service logout );
use Plack::Request;
use Plack::Response;

use Authen::CAS::Client;  

=head1 Arguments 

=head2 server 

CAS server base URL (used by the Authen::CAS::Client constructor).

=head2 service

URL of the application using CAS Authentication.

=head2 logout

This url will trigger the logout URL of the CAS server.

=cut

# ABSTRACT: PSGI CAS Authentication Middleware
our $VERSION = '0.0';

sub prepare_app {
    my ( $self ) = @_;
    $self->logout or $self->logout('/logout');
    $self;
} 

sub unauthorized {
    my $self = shift;
    my $body = 'Authorization required';
    [ 401
    , [ 'Content-Type' => 'text/plain'
        , 'Content-Length' => length $body
        , 'WWW-Authenticate' => 'Negotiate' ]
    , [ $body ] ];
}

# method call ($env) {
sub call {
    my ( $self, $env ) = @_;

    # those are 2 valid examples of reply
    # return Plack::Response->new(404)->finalize;
    # return
    #      [ 201
    #     , ["Content-Type", "text/plain"]
    #     , ["hello Test::More"] ];
    
    my $cas = Authen::CAS::Client->new( $self->server )
        or return Plack::Response->new('500')->finalize;

    $env->{PATH_INFO} eq $self->logout and return do {
        my $r = Plack::Response->new;
        $r->redirect( $cas->logout_url( url => $self->service ) );
        $r->finalize; 
    };

    my $req = Plack::Request->new($env);

    my $ticket = $req->param('ticket') or return do {

        # here i break everything done by other middleware!
        # fuck you web developpers ! 
        
        my $r = Plack::Response->new;
        $r->redirect( $cas->login_url($self->service) );
        return $r->finalize; 

    };

    my $r = $cas->service_validate( $self->service, $ticket );
    if ( $r->is_success ) { $self->app->($env) }
    else { $self->unauthorized } 

}

1;

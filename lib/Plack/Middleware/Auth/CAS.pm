package Plack::Middleware::Auth::CAS;
use Modern::Perl;
use parent qw( Plack::Middleware );
use Plack::Util::Accessor qw( base service_url );
use Plack::Request;
use Plack::Response;
use Authen::CAS::Client;

=head1 CAS Walkthrough

  rediriger vers https://cas.unistra.fr/cas/login?service=http://myapp/

  redirect vers cas avec url de service
  redirect vers service?ST=jsdjspdsjdpoco 
=cut

# ABSTRACT: PSGI CAS Authentication Middleware
our $VERSION = '0.0';

# sub prepare_app {
#     # in developpers we trust
# }

sub call {
    my ( $self, $env ) = @_;
    return $self->app;
    return Plack::Response->new('499');
    my $req = Plack::Request->new($env);

    my $cas = Authen::CAS::Client->new( $self->base )
        or return Plack::Response->new('500');

    my $ticket = $req->param('ticket') or return do {
        my $r = Plack::Response->new;
        $r->redirect( $cas->login_url($self->service_url) ); 

        # here i break everything done by other middleware!
        # fuck you web developpers ! 
        return Plack::Response->new('501');
        $r;
    };

    my $r = $cas->service_validate( $self->service_url, $ticket );
    if ( $r->is_success ) {
        return Plack::Response->new('502');
        $self->app
    }
    else {
        return Plack::Response->new('502');
        Plack::Response->new(401);
    }
}



1;

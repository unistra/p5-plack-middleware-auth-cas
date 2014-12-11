use Modern::Perl;
use XML::Tag::html5;
use Plack::Builder;
use Method::Signatures;
use re '/xms';

builder {
    enable qw( Static root static/ )
    , path => qr{[.] ( js | png | jpg )$}; 
    enable qw( Session store File ); 
    enable
    qw( Auth::CAS
        server  https://cas.unistra.fr/cas/
        service http://ramirez.u-strasbg.fr:5000
        logout  /logout
    );

    sub {
        my ( $self, $env ) = @_;
        use Plack::Session;
        my $session = Plack::Session->new( $env );
        [ 201
        , ["Content-Type", "text/html"]
        , [ html { 
                head {
                    title {"cas example"}
                }, 
                body {
                    h1 { "hello, ". $session->get('user') },
                    form {
                        +{qw( action /logout method post ) }
                        , input_submit logout => "get me out of here"
                    },
                    ( map import_js
                        , 'http://code.jquery.com/jquery-1.11.1.min.js'
                        , 'behave.js' )
                }, 
            }
        ] ]
    }
};


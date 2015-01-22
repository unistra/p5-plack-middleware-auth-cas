use Eirotic;
use XML::Tag::html5;
use Plack::Builder;
use Method::Signatures;
use re '/xms';

func accueil ( $env ) {
    html { 
        head {
            title {"cas example"}
        }, 
        body {
            h1 {"your env"},
            dl {
                map {
                    dt { $_ }
                    , dd {
                        my ( $v, $r ) = map { $_, ref $_ } $$env{$_};
                        $r ? $r : $v 
                    }
                } keys %$env
            },
            h1 {"your rights"},
            # h1 { "hello, ". $session->get('user') },
            form {
                +{qw( action /logout method post ) }
                , input_submit logout => "get me out of here"
            },
            ( map import_js
                , 'http://code.jquery.com/jquery-1.11.1.min.js'
                , 'behave.js' )
        }, 
    }
} 

# func info ( $env ) {
#     html { 
#         head {
#             title {"cas example"}
#         }, 
#         body { "pouet", 
#             $env->{PATH_INFO}
#             , 
#         }, 
#     }
# }


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
        my ( $env ) = @_;
        my $r = Plack::Session->new( $env);

        [ 200
        , ["Content-Type", "text/html"]
        , [ $env->{PATH_INFO} =~ /ac/ ? accueil $env : accueil $env ] ]
        # use Plack::Session;
        # my $session = Plack::Session->new( $env );
    }
};


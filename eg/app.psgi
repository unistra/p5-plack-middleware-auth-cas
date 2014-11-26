use Modern::Perl;
use XML::Tag::html5;
use Plack::Builder;
#use Method::Signatures; 

builder { 

    enable
    qw( Plack::Middleware::Auth::CAS
        server  https://cas.unistra.fr/cas/
        service http://ramirez.u-strasbg.fr:5000
        logout  /logout
    );

    sub {
        # my ( $self, $senv ) = @_;
        [ 201
        , ["Content-Type", "text/html"]
        , [ '<html>
            <body>
            <form action="/logout">
            <input type="submit" value="logout"/>
            </form>
            </body>
            </html>' ] ]
    }
};


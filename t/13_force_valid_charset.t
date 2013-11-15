use strict;
use warnings;
use utf8;
use Encode;
use HTTP::Request::Common;
use Plack::Response::AutoEncode;

use Plack::Test;
use Test::More;

my $app_factory = sub {
    my ($charset, $body) = @_;
    sub {
        my $res = Plack::Response::AutoEncode->new(
            200,
            ['Content-Type' => 'text/html;charset='.$charset],
            [$body]
        );
        $res->finalize;
    };
};

subtest 'Unknown encoding method' => sub {
    my $body = 'ルビースト';
    test_psgi( $app_factory->('utf8', $body) => sub {
        #                     ~~~~~~ It is unsuitable as charset.
        my $cb = shift;
        my $res = $cb->(GET '/');
        is $res->code, 200;
        is $res->header('Content-Type'), 'text/html;charset=UTF-8', 'Force valid charset';
        is $res->content, Encode::encode('utf8', $body);
    } );
};

done_testing;

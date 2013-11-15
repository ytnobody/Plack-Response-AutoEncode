use strict;
use warnings;
use utf8;
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
    test_psgi($app_factory->('UNKNOWN_METHOD', $body) => sub {
        my $cb = shift;
        my $res = $cb->(GET '/');
        is $res->code, 500;
        is $res->header('Content-Type'), 'text/html;charset=UNKNOWN_METHOD';
        is $res->content, 'Invalid charset was detected';
    });
};

done_testing;

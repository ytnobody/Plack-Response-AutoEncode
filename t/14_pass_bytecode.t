use strict;
use warnings;
use utf8;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use Encode;
use Plack::Response::AutoEncode;

my $app = sub {
    my $res = Plack::Response::AutoEncode->new(
        200,
        ['Content-Type' => 'text/html; charset=EUC-JP'],
        [Encode::encode('EUC-JP', '私は日本人です。')],
    );
    $res->finalize;
};

test_psgi( $app => sub {
    my $cb = shift;
    my $res = $cb->(GET '/');
    is($res->code, 200);
    is_deeply($res->content, Encode::encode('EUC-JP', Encode::encode('EUC-JP', '私は日本人です。')), 'BROKEN CONTENT');
} );

done_testing;

use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use Plack::Response::AutoEncode;
use Encode;
use utf8;

subtest 'simple' => sub {
    my $body = 'わたしは日本人であります';

    my $app_gen = sub {
        my ($charset, $body) = @_;
        sub { 
            my $res = Plack::Response::AutoEncode->new(200, ['Content-Type' => 'text/html;charset='.$charset], [$body]); 
            $res->finalize;
        };
    };

    test_psgi( $app_gen->('Shift_JIS', $body) => sub {
        my $cb = shift;
        my $res = $cb->(GET '/');
        is $res->code, 200;
        is $res->header('Content-Type'), 'text/html;charset=Shift_JIS';
        is $res->content, Encode::encode('shiftjis', $body);
    } );

    test_psgi( $app_gen->('UTF-8', $body) => sub {
        my $cb = shift;
        my $res = $cb->(GET '/');
        is $res->code, 200;
        is $res->header('Content-Type'), 'text/html;charset=UTF-8';
        is $res->content, Encode::encode('utf8', $body);
    } );

    test_psgi( $app_gen->('EUC-JP', $body) => sub {
        my $cb = shift;
        my $res = $cb->(GET '/');
        is $res->code, 200;
        is $res->header('Content-Type'), 'text/html;charset=EUC-JP';
        is $res->content, Encode::encode('euc-jp', $body);
    } );

};

done_testing;

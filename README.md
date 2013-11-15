# NAME

Plack::Response::AutoEncode - Plack response with automatic encoding feature

# SYNOPSIS

in your PSGI application

    use utf8;
    use Plack::Response::AutoEncode;

    my $app = sub {
        my $body = '私は日本人です。';
        my $res  = Plack::Response::AutoEncode->new(200, ['text/html; charset=UTF-8'], [$body]);
        $res->finalize;
    };

# DESCRIPTION

Plack::Response::AutoEncode is subclass of Plack::Response.

When application returns a response that contains "text/\*" in Content-Type header, encode automatically each unencoded content by charset that is in Content-Type header.

You __MUST__ set content-body data in perl-string.

For example. If you want to response with Shift\_JIS encoding, you can it as followings.

    use utf8;
    use Plack::Response::AutoEncode;

    my $app = sub {
        my $body = '私は日本人です。';
        ### like as s|UTF-8|Shift_JIS|;
        my $res  = Plack::Response::AutoEncode->new(200, ['text/html; charset=Shift_JIS'], [$body]);
        $res->finalize;
    };

# LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

ytnobody <ytnobody@gmail.com>

moznion

package Plack::Response::AutoEncode;
use strict;
use warnings;
use parent 'Plack::Response';
use Carp ();
use Email::MIME::ContentType () ;
use Encode;
our $VERSION = "0.02";

sub finalize {
    my $self = shift;
    if ($self->content_type =~ /^text\//) {
        my $data    = Email::MIME::ContentType::parse_content_type($self->header('Content-Type'));
        my $charset = $data->{attributes}{charset};
        if ($charset) {
            my $content = ref($self->content) eq 'ARRAY' ?
                [ map { $self->_encode_gracefully($charset, $_) } @{$self->content} ] :
                $self->_encode_gracefully( $self->content )
            ;
            $self->content($content);

            if ($self->{encoding}) {
                $data->{attributes}{charset} = $self->{encoding}->mime_name;
            }

            $self->headers->{'content-type'} = $self->_build_content_type($data);
        }
    }
    $self->SUPER::finalize(@_);
}

sub _encode_gracefully {
    my ($self, $charset, $str) = @_;

    $self->{encoding} = Encode::find_encoding($charset);
    unless ($self->{encoding}) {
        Carp::carp qq![Error] Invalid charset was detected ("$charset")!;

        # $str is must perl-string. Return it that is encoded by UTF-8 for the time being unless defined 'encoding'...
        return Encode::encode('utf8', $str);
    }

    $self->{encoding}->encode($str);
}

sub _build_content_type {
    my ($self, $data) = @_;

    my $content_type_str = "$data->{discrete}/$data->{composite}";
    for my $k (keys %{$data->{attributes}}) {
        $content_type_str .= ";$k=$data->{attributes}->{$k}";
    }
    return $content_type_str;
}
1;
__END__

=encoding utf-8

=head1 NAME

Plack::Response::AutoEncode - Plack response with automatic encoding feature

=head1 SYNOPSIS

in your PSGI application

    use utf8;
    use Plack::Response::AutoEncode;

    my $app = sub {
        my $body = '私は日本人です。';
        my $res  = Plack::Response::AutoEncode->new(200, ['text/html; charset=UTF-8'], [$body]);
        $res->finalize;
    };

=head1 DESCRIPTION

Plack::Response::AutoEncode is subclass of Plack::Response.

When application returns a response that contains "text/*" in Content-Type header, encode automatically each unencoded content by charset that is in Content-Type header.

You B<MUST> set content-body data in perl-string.

For example. If you want to response with Shift_JIS encoding, you can it as followings.

    use utf8;
    use Plack::Response::AutoEncode;

    my $app = sub {
        my $body = '私は日本人です。';
        ### like as s|UTF-8|Shift_JIS|;
        my $res  = Plack::Response::AutoEncode->new(200, ['text/html; charset=Shift_JIS'], [$body]);
        $res->finalize;
    };

=head1 LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

moznion

=cut


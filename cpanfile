requires 'perl', '5.008001';
requires 'Plack::Request';
requires 'Encode';
requires 'Email::MIME::ContentType';

on 'test' => sub {
    requires 'Encode';
    requires 'HTTP::Request::Common';
    requires 'Test::More', '0.98';
};


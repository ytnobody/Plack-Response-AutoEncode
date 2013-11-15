requires 'perl', '5.008001';
requires 'Plack::Request';
requires 'Plack::Response';
requires 'Encode';
requires 'Email::MIME::ContentType';
requires 'parent';

on configure => sub {
    requires 'CPAN::Meta';
    requires 'CPAN::Meta::Prereqs';
    requires 'Module::Build';
};

on 'test' => sub {
    requires 'HTTP::Request::Common';
    requires 'Capture::Tiny';
    requires 'Plack::Test';
    requires 'Test::More', '0.98';
};

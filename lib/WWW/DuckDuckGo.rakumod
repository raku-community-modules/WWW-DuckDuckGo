unit class WWW::DuckDuckGo;

use JSON::Fast;
use HTTP::UserAgent;
use URI;
use URI::Escape;
use WWW::DuckDuckGo::ZeroClickInfo;

has Str $!duckduckgo_api_url = 'http://api.duckduckgo.com/';
has Str $!duckduckgo_api_url_secure = 'https://api.duckduckgo.com/';
has     $!zeroclickinfo = WWW::DuckDuckGo::ZeroClickInfo;
has     $!http-agent    = HTTP::UserAgent.new;
has Int $!forcesecure   = 0;
has Int $!safeoff       = 0;
has Int $!html          = 0;
has Hash $!params;

multi method zci($q) {
    self.zeroclickinfo([$q]);
}

multi method zci(*@rest) {
    self.zeroclickinfo(@rest);
}

method zeroclickinfo_request_base($for_uri, @query_fields) {
    my $query = @query_fields.join(' ');
    $query = uri-escape($query);
    my $uri = URI.new($for_uri);
    # FIXME: when it'll work with Perl 6 URI module;
    # $uri.query_param( q => $query); is much more safe.
    $uri ~= "?q=$query";
    $uri ~= "&o=json";
    $uri ~= "&kp=-1" if $!safeoff;
    $uri ~= "&no_redirect=1";
    $!html ?? ($uri ~= "&no_html=0") !! ($uri ~= "&no_html=1");
    for $!params.kv -> $k, $v {
        $uri ~= "&$k=$v";
    };
    $uri
}

method zeroclickinfo_request_secure(@query_fields) {
    return if !@query_fields;
    self.zeroclickinfo_request_base($!duckduckgo_api_url_secure, @query_fields);
}

method zeroclickinfo_request(@query_fields) {
    return if !@query_fields;
    self.zeroclickinfo_request_base($!duckduckgo_api_url, @query_fields);
}

method zeroclickinfo(@query_fields) {
    return if !@query_fields;
    my $res;

    try {
    my $url = self.zeroclickinfo_request_secure(@query_fields);
        $res = $!http-agent.get($url);
    }
    if !$!forcesecure && (!$res || !$res.is-success) {
        warn("HTTP request failed " ~ $res.status-line ~ "\n")
          if ($res && !$res.is-success);
        warn("Can't access $!duckduckgo_api_url_secure failing back to: $!duckduckgo_api_url");
        my $url = self.zeroclickinfo_request(@query_fields);
        $res = $!http-agent.get($url);
    }
    self.zeroclickinfo_by_response($res);
}

method zeroclickinfo_by_response($res) {
    if $res.is-success {
        my $result = from-json($res.content);
        return $!zeroclickinfo.new($result);
    }
    else {
        die 'HTTP request failed: ' ~ $res.status-line ~ "\n";
    }
}

=begin pod

=head1 NAME

WWW::DuckDuckGo - Bindings to DuckDuckGo search API

=head1 SYNOPSIS

=begin code :lang<raku>

use WWW::DuckDuckGo;

my $duck = WWW::DuckDuckGo.new;
my $zeroclickinfo1 = $duck.zci('duck duck go');
my $zeroclickinfo2 = $duck.zci('one', 'another');

=end code

=head1 DESCRIPTION

This class provides a way to get data from DuckDuckGo search service.
The basic idea is to create a class instance that represents JSON answer
from the server for every query.

This is a functional port of the Perl module of the same name, see
L<C<WWW::DuckDuckGo>|https://metacpan.org/pod/WWW::DuckDuckGo>.

=head1 AUTHOR

Alexander Kiryuhin

=head1 COPYRIGHT AND LICENSE

Copyright 2016 - 2021 Alexander Kiryuhin

Copyright 2024 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4

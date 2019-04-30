package Domeneshop::API;

use strict;
use warnings;

use JSON::XS;
use HTTP::Tiny;
use MIME::Base64;
use URI::Encode;

my $uri = URI::Encode->new( { encode_reserved => 1 } );

sub new
{
    my ($class, $args) = @_;
    
    my $self = bless {
        url    => $args->{url} || 'https://api.domeneshop.no/v0',
        token  => $args->{token},
        secret => $args->{secret},
        ua     => HTTP::Tiny->new(agent => "Domeneshop.pm v".$Domeneshop::VERSION)
    }, $class;

    return $self;
}

sub _join_params {
    my($self, $params) = @_;
    return join('&', map{$uri->encode($_) . '=' . $uri->encode($params->{$_})} keys %{$params});
}

sub api_call {
    my($self, $options) = @_;

    my $method   = $options->{method} || 'GET';
    my $endpoint = $options->{endpoint} || '/';
    my $indata   = $options->{data};
    my $params   = $options->{params};
    my $url      = $self->{url} . $endpoint;

    if($params) {
        $url .= '?' . $self->_join_params($params);
    }

    my $auth = encode_base64($self->{token}.':'.$self->{secret}, "");

    my $req_option = {
        headers => {
            "Content-Type"  => "application/json",
            "Accept"        => "application/json",
            "Authorization" => "Basic $auth"
        }
    };

    if($indata) {
        $req_option->{content} = encode_json($indata);
    }

    my $result = $self->{ua}->request($method, $url, $req_option); 
    my $data = {};
    if($result->{content}) {
        $data = decode_json($result->{content});
    }

    return {
        status  => $result->{status},
        reason  => $result->{reason},
        headers => $result->{headers}, 
        content => $data
    };
}


1;
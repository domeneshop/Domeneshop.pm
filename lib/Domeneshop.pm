package Domeneshop;

use v5.10;
use strict;
use warnings;

our $VERSION = 0.1;

use Domeneshop::API;
use Domeneshop::DNS;

sub new
{
    my ($class, $args) = @_;
    
    my $api = new Domeneshop::API($args);

    return bless {
        api => $api,
        dns => new Domeneshop::DNS($api)
    }, $class;
}

sub dns {
    my ($self) = @_;
    return $self->{dns};
}

sub get_domains {
    my ($self) = @_;
    my $res = $self->{api}->api_call({method => 'GET', endpoint => '/domains'});
    return $res->{content};
}

sub get_domain {
    my ($self, $id) = @_;
    my $res = $self->{api}->api_call({method => 'GET', endpoint => "/domains/${id}"});
    return $res->{content};
}

1;
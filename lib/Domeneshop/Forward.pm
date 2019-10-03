package Domeneshop::Forwards;

use strict;
use warnings;

sub new
{
    my ($class, $api) = @_;
    
    my $self = bless {
        api => $api
    }, $class;

    return $self;
}

sub get_forwards {
    my ($self, $domain_id) = @_;

    my $res = $self->{api}->api_call({method => 'GET', endpoint => "/domains/${domain_id}/forwards"});
    return $res->{content};
}

sub get_forward {
    my ($self, $domain_id, $host) = @_;

    my $res = $self->{api}->api_call({method => 'GET', endpoint => "/domains/${domain_id}/forwards/${host}"});
    return $res->{content};
}

sub create_forward {
    my ($self, $domain_id, $forward) = @_;

    my $res = $self->{api}->api_call({method => 'POST', endpoint => "/domains/${domain_id}/forwards", data => $forward});
    my $location = $res->{headers}->{location};
    if($location) {
        return (split '/',$location)[-1];
    }
    die 'This should not happen.';
}

sub modify_forward {
    my ($self, $domain_id, $host, $forward) = @_;

    my $res = $self->{api}->api_call({method => 'PUT', endpoint => "/domains/${domain_id}/forwards/${host}", data => $forward});
}


sub delete_forward {
    my ($self, $domain_id, $host) = @_;

    my $res = $self->{api}->api_call({method => 'DELETE', endpoint => "/domains/${domain_id}/forwards/${host}"});
}


1;
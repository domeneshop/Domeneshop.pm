package Domeneshop::Invoices;

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

sub get_invoices {
    my ($self, $status) = @_;

    my $opt = {
        method   => 'GET',
        endpoint => "/invoices${$status}"
    };

    if($status) {
        $opt->{params} => {
            status => $status
        }
    }

    my $res = $self->{api}->api_call($opt);
    return $res->{content};
}

sub get_invoice {
    my ($self, $invoice_id) = @_;

    my $res = $self->{api}->api_call({method => 'GET', endpoint => "/invoices/${invoice_id}"});
    return $res->{content};
}

1;
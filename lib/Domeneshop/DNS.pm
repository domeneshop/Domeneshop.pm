package Domeneshop::DNS;

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

sub get_records {
    my ($self, $domain_id) = @_;

    my $res = $self->{api}->api_call({method => 'GET', endpoint => "/domains/${domain_id}/dns"});
    return $res->{content};
}

sub get_record {
    my ($self, $domain_id, $record_id) = @_;

    my $res = $self->{api}->api_call({method => 'GET', endpoint => "/domains/${domain_id}/dns/${record_id}"});
    return $res->{content};
}

sub create_record {
    my ($self, $domain_id, $record) = @_;
    $self->_validate($record);

    my $res = $self->{api}->api_call({method => 'POST', endpoint => "/domains/${domain_id}/dns", data => $record});
    my $location = $res->{headers}->{location};
    if($location) {
        return +(split '/',$location)[-1];
    }
    die 'This should not happen.';
}

sub modify_record {
    my ($self, $domain_id, $record_id, $record) = @_;
    $self->_validate($record);

    my $res = $self->{api}->api_call({method => 'PUT', endpoint => "/domains/${domain_id}/dns/${record_id}", data => $record});
}


sub delete_record {
    my ($self, $domain_id, $record_id) = @_;

    my $res = $self->{api}->api_call({method => 'DELETE', endpoint => "/domains/${domain_id}/dns/${record_id}"});
}

sub _validate {
    my ($self, $record) = @_;
    my @common = ('host', 'data', 'type');
    my $types = {
        'A'     => [],
        'AAAA'  => [],
        'CNAME' => [],
        'ANAME' => [],
        'MX'    => ['priority'],
        'SRV'   => ['priority', 'weight', 'port'],
        'TLSA'  => ['usage', 'selector', 'dtype'],
        'DS'    => ['tag', 'alg', 'digest'],
        'CAA'   => ['flags', 'tag']
    };

    if (!$record->{'type'}) {
        die 'Record does not have any type';
    }
    if (! exists $types->{$record->{'type'}}){
        die 'Record has an unknown type';
    }

    my @fields = (@common, @{$types->{$record->{'type'}}});

    if ($record->{'id'}) {
        push @fields, 'id';
    }
    if ($record->{'ttl'}) {
        push @fields, 'ttl';
    }

    for my $itm (@fields) {
        if (! exists $record->{$itm}) {
            die "Record missing required field [$itm]";
        }
    }

    if (scalar @fields  < scalar keys %$record) {
        die 'Too many fields in object';
    }
}


1;
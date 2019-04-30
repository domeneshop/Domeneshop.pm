# Domeneshop Perl Module

Perl Module for the Domeneshop API.

## Requires
- JSON::XS
- HTTP::Tiny
- URI::Encode
- MIME::Base64

## Credentials

Use of this module requires Domeneshop API credentials.

You need an API token and secret. See the [Domeneshop API](https://api.domeneshop.no/docs/) documentation for more information (in Norwegian).

**CAUTION:** You should protect these API credentials as you would the password to your Domeneshop user account. Users who can read this information can use these credentials to issue arbitrary API calls on your behalf. 


## Usage example

```perl
use Domeneshop;
use Data::Dumper;

my $api = new Domeneshop({
    token  => "<api token>",
    secret => "<api secret>"
});

my $domains = $api->get_domains();

for my $domain (@$domains) {
    print Dumper($api->dns->get_records($domain->{id}));
}
```

## Functions

### `new Domeneshop({token => "", secret => ""})`

Creates a new Domeneshop API instance.

### `Domeneshop->get_domain(domainId)`

Get information about one of your domains.

#### Returns:
```json
{
    "domain": "example.com",
    "expiry_date": "2120-01-01",
    "id": 1234567890,
    "nameservers": [ 
        "ns1.hyp.net", 
        "ns2.hyp.net", 
        "ns3.hyp.net" 
    ],
    "registered_date": "1990-01-01",
    "registrant": "ICANN",
    "renew": true,
    "services":
    { 
        "dns": true, 
        "email": false, 
        "registrar": true, 
        "webhotel": "none"
    },
    "status": "active"
}
```

### `Domeneshop->get_domains()`

List all domains on your account.

Returns a list of objects in the same shape as `getDomain(domainId)`.

### `Domeneshop->dns`

Returns object with all methods to manipulate DNS records for domains.

### `Domeneshop->dns->get_record(domain_id, record_id)`

Get a specific DNS record for a domain.

**Note:**: The host field does not include the domain name. An A record for `www.example.com` should only have `www` in its host field.

#### Returns:
```json
{
    "data": "127.0.0.1",
    "host": "www",
    "id": 1591030,
    "ttl": 3600,
    "type": "A"
}
```

### `Domeneshop->dns->get_records(domain_id)`

List all DNS records for a domain.

### `Domeneshop->dns->create_record(domain_id, record)`

Creates a new DNS record for a domain. The record format is JSON with required parameters like the one returned from **getRecord**.

### `Domeneshop->dns->modify_record(domain_id, record_id, record)`

Modifies a specific DNS record for a domain.

**Note:** You can't modify the host nor the type field. If you want to modify these fields, delete the existing DNS record and recreate it.

### `Domeneshop->dns->delete_record(domain_id, record_id)`

Deletes a specific DNS record for a domain.
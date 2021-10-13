# Google Ssl Cert Tool

## Usage

    google-ssl-cert create [NAME] [OPTIONS]

When no cert name is provided, one will be generated for you:

    $ google-ssl-cert create
    Google SSL Cert Created: google-ssl-cert-20211013203211

Check that cert was created on google cloud:

    $ gcloud compute ssl-certificates list
    NAME                            TYPE          CREATION_TIMESTAMP             EXPIRE_TIME                    MANAGED_STATUS
    google-ssl-cert-20211013203211  SELF_MANAGED  2021-10-13T13:16:28.304-07:00  2022-10-12T17:22:01.000-07:00

You can also specify the cert name:

    $ google-ssl-cert create google-ssl-cert-1
    Google SSL Cert Created: google-ssl-cert-1

Check that cert was created on google cloud:

    $ gcloud compute ssl-certificates list
    NAME                            TYPE          CREATION_TIMESTAMP             EXPIRE_TIME                    MANAGED_STATUS
    google-ssl-cert-1               SELF_MANAGED  2021-10-13T13:17:04.192-07:00  2022-10-12T17:22:01.000-07:00

The cert name will also be saved to Google Secret Manager so you can later reference it.



## Setup

* The env var `GOOGLE_PROJECT` and must be set.
* A service account as must be set up with `GOOGLE_APPLICATION_CREDENTIALS`. IE: `export GOOGLE_APPLICATION_CREDENTIALS=~/.gcp/credentials.json`

To check that GOOGLE_APPLICATION_CREDENTIALS is valid and is working you can use the [boltops-tools/google_check](https://github.com/boltops-tools/google_check) test script to check. Here are the summarized commands:

    git clone https://github.com/boltops-tools/google_check
    cd google_check
    bundle
    bundle exec ruby google_check.rb

## Cert Files Conventions

If you name your cert files in your current folder conventionally like so:

    server.csr # cert signing request
    server.key # private key
    server.crt # signed cert

or:

    cert.csr # cert request
    key.pem  # private key
    cert.pem # signed cert

The tool is able to detect it and automatically use those files to create the cert.

You can also specify the path to the certificate and private key explicitly:

    google-ssl-cert create --private-key server.key --certificate server.crt

## Installation

Add this line to your application's Gemfile:

    gem "google-ssl-cert"

And then execute:

    bundle

Or install it yourself as:

    gem install google-ssl-cert

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

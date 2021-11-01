# Google Ssl Cert Rotation Tool

[![BoltOps Badge](https://img.boltops.com/boltops/badges/boltops-badge.png)](https://www.boltops.com)

A Google SSL Cert rotation automation tool.

## How Does It Work?

You should run this tool in the folder with your cert files. The cert files can be inferred conventionally or explicitly specified. Tool can be used in conjuction with [Kubes](https://kubes.guru/) and the [google_secret](https://kubes.guru/docs/helpers/google/secrets/) helper. It can be used to automate the SSL cert rotation process.

This is done by generating a new SSL cert and storing that name to Google secrets.  All the user needs to do is be in the folder with the cert private key and signed cert. These files are typically named: `private.key` and `certificate.crt`.  The key is that the Google Secret name itself does not change, only it's value.

### Kubes Kuberbetes YAML

Your Kuberbetes YAML files can be built with [Kubes](https://kubes.guru/) with the `google_secret` helper which references the cert name.

Example `ingress.yaml` with an L7 external load balancer and global cert.

.kubes/resources/web/ingress.yaml:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web
  annotations:
    ingress.gcp.kubernetes.io/pre-shared-cert: '<%= google_secret("cert-app1", base64: false) %>'
spec:
  defaultBackend:
    service:
      name: web
      port:
        number: 80
```

The `.kubes/resources/web/ingress.yaml` code remains the same, but the generated/compiled ``.kubes/output/web/ingress.yaml`` will have the new Google SSL Cert name.  This triggers Kuberbetes to do a rolling deploy properly.

## Summary of Steps

1. Use the `google-ssl-cert create` command to create new SSL cert and save the name to Google Secrets.  The value in the Google Secret can be later referenced.
2. Deploying your application to Kuberbetes and using the Kubes `google_secret` helper that references the new cert name.
3. Pruning the old cert names with the `google-ssl-cert prune` command.

## Usage: Quick Start

Make sure you have the cert files in your current folder:

    $ ls
    private.key  certificate.crt

Command synopsys:

    google-ssl-cert create CERT_NAME

Example:

    $ google-ssl-cert create cert-app1
    Global cert created: cert-app1-global-20211021155725
    Secret saved: name: cert-app1 value: cert-app1-global-20211021155725

The secret conventionally is the same as the cert name. You can override it with `--secret-name`.

Check that cert and secret was created on google cloud:

    % gcloud compute ssl-certificates list
    NAME                             TYPE          CREATION_TIMESTAMP             EXPIRE_TIME                    MANAGED_STATUS
    cert-app1-global-20211021155725  SELF_MANAGED  2021-10-21T08:57:26.005-07:00  2022-01-12T15:59:59.000-08:00
    ~/environment/cert-files git:master aws:tung:us-west-2 gke:default
    %
    $ gcloud secrets versions access latest --secret cert-app1
    cert-app1-global-20211021155725

## Usage: Region Cert

If you need to create a region cert instead, IE: for internal load balancers, specify the `--no-global` flag. Example:

    $ google-ssl-cert create cert-app1 --no-global
    Region cert created: cert-app1-us-central1-20211021155852 in region: us-central1
    Secret saved: name: cert-app1 value: cert-app1-us-central1-20211021155852

Check that cert and secret was created on google cloud:

    $ gcloud compute ssl-certificates list
    NAME                                  TYPE          CREATION_TIMESTAMP             EXPIRE_TIME                    MANAGED_STATUS
    cert-app1-us-central1-20211021155852  SELF_MANAGED  2021-10-21T08:58:53.514-07:00  2022-01-12T15:59:59.000-08:00

## Required Env Vars

These env vars should be set:

Name | Description
--- | ---
GOOGLE\_APPLICATION_CREDENTIALS or
GOOGLE_CREDENTIALS | A service account as must be set up. `GOOGLE_APPLICATION_CREDENTIALS` is set to the path of the file. `GOOGLE_CREDENTIALS` is set as the full json data structure. IE: `export GOOGLE_APPLICATION_CREDENTIALS=~/.gcp/credentials.json`
GOOGLE_PROJECT | The env var `GOOGLE_PROJECT` and must be set.
GOOGLE_REGION | The env var `GOOGLE_REGION` and must be set when creating a region-based google ssl cert. So when using the `--no-global` flag

To check that `GOOGLE_APPLICATION_CREDENTIALS` is valid and is working you can use the [boltops-tools/google_check](https://github.com/boltops-tools/google_check) test script to check. Here are the summarized commands:

    git clone https://github.com/boltops-tools/google_check
    cd google_check
    bundle
    bundle exec ruby google_check.rb

## Cert Files Conventions

The tool will look in your current folder for these private keys in the following order:

    private.key
    server.key
    key.pem

And look for these certs:

    certificate.crt
    server.crt
    cert.pem

So, for example, if you name your cert files in your current folder conventionally like so:

    private.key     # private key
    certificate.crt # signed cert

The tool is able to detect it and automatically use those files to create the cert.

You can also specify the path to the certificate and private key explicitly:

    google-ssl-cert create cert-app1 --private-key server.key --certificate server.crt

## Prune

To prune or delete old google ssl certs after rotating:

    google-ssl-cert prune CERT_NAME

## Installation

    gem install google-ssl-cert

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

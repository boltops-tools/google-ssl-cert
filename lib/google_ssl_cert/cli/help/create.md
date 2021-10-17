## Examples

When no cert name is provided, one will be generated for you:

    $ google-ssl-cert create
    Google SSL Cert Created: google-ssl-cert-20211013203211

Check that cert was created on google cloud:

    $ gcloud compute ssl-certificates list
    NAME                            TYPE          CREATION_TIMESTAMP             EXPIRE_TIME                    MANAGED_STATUS
    google-ssl-cert-20211013203211  SELF_MANAGED  2021-10-13T13:16:28.304-07:00  2022-10-12T17:22:01.000-07:00

You can also specify the cert name:

    $ google-ssl-cert create --cert-name google-ssl-cert-1 --no-timestamp
    Google SSL Cert Created: google-ssl-cert-1

Check that cert was created on google cloud:

    $ gcloud compute ssl-certificates list
    NAME                            TYPE          CREATION_TIMESTAMP             EXPIRE_TIME                    MANAGED_STATUS
    google-ssl-cert-1               SELF_MANAGED  2021-10-13T13:17:04.192-07:00  2022-10-12T17:22:01.000-07:00

## More Examples

    google-ssl-cert create
    google-ssl-cert create --private-key /path/to/key/server.key
    google-ssl-cert create --certificate /path/to/certificate/server.crt
    google-ssl-cert create --no-save-secret
    google-ssl-cert create --secret-name secret-name

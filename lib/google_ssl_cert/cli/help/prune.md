Prune only deletes google ssl cert resources if the cert name has a timestamp at the end with 14 digits as the format.  Example:

    google-ssl-cert-20211014221403

## Examples

Lets say there are 3 certs:

    $ gcloud compute ssl-certificates list
    NAME                            TYPE          CREATION_TIMESTAMP             EXPIRE_TIME                    MANAGED_STATUS
    google-ssl-cert-20211014221406  SELF_MANAGED  2021-10-14T15:14:06.592-07:00  2022-01-12T15:59:59.000-08:00
    google-ssl-cert-20211014221546  SELF_MANAGED  2021-10-14T15:15:46.400-07:00  2022-01-12T15:59:59.000-08:00
    google-ssl-cert-20211014221549  SELF_MANAGED  2021-10-14T15:15:49.624-07:00  2022-01-12T15:59:59.000-08:00

Running prune will delete the 2 oldest certs.

    $ google-ssl-cert prune
    Will delete the following global certs:
      google-ssl-cert-20211014221406
      google-ssl-cert-20211014221546
    Are you sure? (y/N) y
    Deleted global cert: google-ssl-cert-20211014221406
    Deleted global cert: google-ssl-cert-20211014221546

Confirm that only 1 cert is kept.

    $ gcloud compute ssl-certificates list
    NAME                            TYPE          CREATION_TIMESTAMP             EXPIRE_TIME                    MANAGED_STATUS
    google-ssl-cert-20211014221549  SELF_MANAGED  2021-10-14T15:15:49.624-07:00  2022-01-12T15:59:59.000-08:00
    $
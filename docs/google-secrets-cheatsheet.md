## Secrets Commands

    gcloud secrets list
    gcloud secrets create testsecret
    gcloud secrets versions add testsecret --data-file="/tmp/testsecret.txt"
    gcloud secrets versions access latest --secret testsecret

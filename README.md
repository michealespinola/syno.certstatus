# syno.certstatus
A script to check the expiration status of certificates on Synology NAS

## Example Output (no warnings)

### No expiries for default <30 days (complete output)

    # bash syno.certstatus.sh

    Certificate Statuses:
    ----------------------------------------
    Certificate: [1] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
        Subject: SYNOLOGY
        Issuer: [REDACTED] ([REDACTED])
        Expiry: May 13 04:30:37 2024 GMT (316 days)
    ----------------------------------------
    Certificate: [2] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
        Subject: synology.com
        Issuer: Synology Inc. (Synology Inc. CA)
        Expiry: Aug 15 00:39:13 2038 GMT (5523 days)
    ----------------------------------------
    Certificate: [3] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
        Subject: [REDACTED].direct.quickconnect.to
        Issuer: Let's Encrypt (R3)
        Expiry: Aug 19 05:17:45 2023 GMT (48 days)
    ----------------------------------------
    Certificate: [4] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
        Subject: [REDACTED].diskstation.me
        Issuer: Let's Encrypt (R3)
        Expiry: Sep 15 01:48:11 2023 GMT (75 days)
    ----------------------------------------

    STATUS: All certificates have 30 days or more remaining until expiry.

## Example Warnings

### No expiries for <100 days (status area warnings)

    WARNING: Some certificates have less than 100 days remaining until expiry.

    Expiring Certificates:
    * [3] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
    * [4] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem

----

### No expiries for <1000 days (status area warnings)

    WARNING: Some certificates have less than 1000 days remaining until expiry.

    Expiring Certificates:
    * [1] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
    * [3] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
    * [4] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem

----

### No expiries for <10000 days (status area warnings)

    WARNING: Some certificates have less than 10000 days remaining until expiry.

    Expiring Certificates:
    * [1] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
    * [2] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
    * [3] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
    * [4] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem

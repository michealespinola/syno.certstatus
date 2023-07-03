# syno.certstatus
A script to check the expiration status of certificates on Synology NAS.

## Example Syntax:

    syno.certstatus.sh <days?> <directory?>

1. First argument is to specify number of days to compare against (default is 30).
2. Second arguement is to specify a directory to search for certificates. (default is Synology default).

📝: You must specify a <days?> arguement if you intend to also specify a <directory?> arguement.

## Example Output (no warnings)

### No expiries for default <30 days (complete output)

    # bash syno.certstatus.sh

    Certificate Details:
    ----------------------------------------
    Certificate: [1] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
        Subject: SYNOLOGY
        Issuer: [REDACTED]
        Expiry: May 13 04:30:37 2024 GMT (316 days)
    ----------------------------------------
    Certificate: [2] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
        Subject: synology.com
        Issuer: Synology Inc.
        Expiry: Aug 15 00:39:13 2038 GMT (5523 days)
    ----------------------------------------
    Certificate: [3] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
        Subject: [REDACTED].direct.quickconnect.to
        Issuer: Let's Encrypt
        Expiry: Aug 19 05:17:45 2023 GMT (48 days)
    ----------------------------------------
    Certificate: [4] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
        Subject: [REDACTED].diskstation.me
        Issuer: Let's Encrypt
        Expiry: Sep 15 01:48:11 2023 GMT (75 days)
    ----------------------------------------

    STATUS: All certificates have 30 days or more remaining until expiry.

## Example Warnings

### No expiries for <100 days (status area warnings)

    WARNING: Some certificates have less than 100 days until expiry.

    Expiring Certificates:
    * [3] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
    * [4] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem

----

### No expiries for <1000 days (status area warnings)

    WARNING: Some certificates have less than 1000 days until expiry.

    Expiring Certificates:
    * [1] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
    * [3] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
    * [4] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem

----

### No expiries for <10000 days (status area warnings)

    WARNING: Some certificates have less than 10000 days until expiry.

    Expiring Certificates:
    * [1] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
    * [2] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
    * [3] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
    * [4] /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem

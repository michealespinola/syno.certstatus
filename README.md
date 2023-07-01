# syno.certstatus
A script to check the expiration status of certificates on Synology NAS

## Example Output (no expiries for default <30 days)

    # bash syno.certstatus.sh
    
    Certificate Statuses:
    ----------------------------------------
    Certificate: /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
         Issuer: [REDACTED] ([REDACTED])
        Subject: [REDACTED]
         Expiry: May 13 04:30:37 2024 GMT (316 days)
    ----------------------------------------
    Certificate: /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
         Issuer: Synology Inc. (Synology Inc. CA)
        Subject: synology.com
         Expiry: Aug 15 00:39:13 2038 GMT (5523 days)
    ----------------------------------------
    Certificate: /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
         Issuer: Let's Encrypt (R3)
        Subject: [REDACTED].direct.quickconnect.to
         Expiry: Aug 19 05:17:45 2023 GMT (48 days)
    ----------------------------------------
    Certificate: /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
         Issuer: Let's Encrypt (R3)
        Subject: [REDACTED].diskstation.me
         Expiry: Sep 15 01:48:11 2023 GMT (75 days)
    ----------------------------------------
    
    STATUS: All certificates have 30 days or more remaining until expiry.

## Example Output (expiries for specified <100 days)

    # bash syno.certstatus.sh 100
    
    Certificate Statuses:
    ----------------------------------------
    Certificate: /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
         Issuer: [REDACTED] ([REDACTED])
        Subject: [REDACTED]
         Expiry: May 13 04:30:37 2024 GMT (316 days)
    ----------------------------------------
    Certificate: /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
         Issuer: Synology Inc. (Synology Inc. CA)
        Subject: synology.com
         Expiry: Aug 15 00:39:13 2038 GMT (5523 days)
    ----------------------------------------
    Certificate: /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
         Issuer: Let's Encrypt (R3)
        Subject: [REDACTED].direct.quickconnect.to
         Expiry: Aug 19 05:17:45 2023 GMT (48 days)
    ----------------------------------------
    Certificate: /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
         Issuer: Let's Encrypt (R3)
        Subject: [REDACTED].diskstation.me
         Expiry: Sep 15 01:48:11 2023 GMT (75 days)
    ----------------------------------------
    
    WARNING: Some certificates have less than 100 days remaining until expiry.
    
    Expiring Certificates:
     * /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem
     * /usr/syno/etc/certificate/_archive/[REDACTED]/cert.pem

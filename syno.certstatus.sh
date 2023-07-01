#!/usr/bin/env bash
#!/bin/bash
# shellcheck disable=SC2154,SC2181
# shellcheck source=/dev/null
#
# A script to check the expiration status of certificates on Synology NAS
#
# Author @michealespinola https://github.com/michealespinola/syno.plexupdate
#
# Example Synology DSM Scheduled Task type 'user-defined script': 
# bash /volume1/homes/admin/scripts/bash/syno.certstatus.sh <days?> <directory?>

# INITIALIZE VARIABLES AND ARRAYS
cert_folder=${2:-/usr/syno/etc/certificate/_archive}
days_threshold=${1:-30}
exit_status=0
max_length=0
expiring_certificates=()

# LOCATE X.509 CERT.PEM FILES WITHIN THE DIRECTORY HIERARCHY
cert_files=$(find "$cert_folder" -name cert.pem | sort)

# FIND THE MAXIMUM LENGTH OF THE SUMMARY LABELS
labels=("Certificate" "Issuer" "Subject" "Expiry")
for label in "${labels[@]}"; do
    (( ${#label} > max_length )) && max_length=${#label}
done

# SCRAPE METADATA AND DISPLAY DETAILS FOR EACH CERTIFICATE
if [ -n "$cert_files" ]; then
    printf "\n%s\n" "Certificate Statuses:"
    printf '%.0s-' {1..40}
    printf '\n'

    for cert_file in $cert_files; do
        # SCRAPE X.509 CERTIFICATE METADATA USING OPENSSL
          issuer_o=$(openssl x509 -in "$cert_file" -noout -nameopt RFC2253 -issuer  | grep -o 'O=[^,]*'        | cut -d '=' -f 2)
         issuer_cn=$(openssl x509 -in "$cert_file" -noout -nameopt RFC2253 -issuer  | grep -o 'CN=[^,]*'       | cut -d '=' -f 2)
        subject_cn=$(openssl x509 -in "$cert_file" -noout -nameopt RFC2253 -subject | grep -o 'CN=[^,]*'       | cut -d '=' -f 2)
           enddate=$(openssl x509 -in "$cert_file" -noout -nameopt RFC2253 -enddate | grep -o 'notAfter=[^,]*' | cut -d '=' -f 2)

        # CALCULATE DAYS REMAINING UNTIL THE CERTIFICATE EXPIRES
        enddate_epoch=$(date -d "$enddate" +%s)
        current_epoch=$(date +%s)
        days_remaining=$(( (enddate_epoch - current_epoch) / 86400 ))

        # OUTPUT SUMMARY
        printf "%${max_length}s: %s\n" "Certificate" "$cert_file"
        printf "%${max_length}s: %s\n" "Subject"     "$subject_cn"
        printf "%${max_length}s: %s\n" "Issuer"      "$issuer_o ($issuer_cn)"
        printf "%${max_length}s: %s\n" "Expiry"      "$enddate ($days_remaining days)"
        printf '%.0s-' {1..40}
        printf '\n'

        # CHECK IF CERTIFICATE EXPIRES WITHIN THRESHOLD
        if (( days_remaining < days_threshold )); then
            exit_status=1
            expiring_certificates+=("$cert_file")
        fi
    done

    # FORCED EXIT STATUS SCRIPT NOTIFICATIONS
    if [[ $exit_status -ne 0 ]]; then
        printf "\n%s\n" "WARNING: Some certificates have less than $days_threshold days remaining until expiry."
        printf "\n%s\n" "Expiring Certificates:"
        for cert in "${expiring_certificates[@]}"; do
            printf " * %s\n" "$cert"
        done
    else
        printf "\n%s\n" "STATUS: All certificates have $days_threshold days or more remaining until expiry."
    fi
    printf "\n"

else
    printf "%s\n" "No certificates found in: $cert_folder"
    exit_status=1
fi

exit "$exit_status"

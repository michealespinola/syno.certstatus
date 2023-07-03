#!/usr/bin/env bash
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
cert_expiries=()                                        # Initialize certificate expiry array
cert_files=()                                           # Initialize certificate files array
cert_folder=${2:-/usr/syno/etc/certificate/_archive}    # Default cert folder or replace with argument2
days_threshold=${1:-30}                                 # Default expiry threshold or replace with argument1
exit_status=0                                           # Initialize exit status
max_length=0                                            # Initialize summary label length for display alignment

# FIND THE MAXIMUM LENGTH OF THE SUMMARY LABELS
labels=("Certificate" "Issuer" "Subject" "Expiry")
for label in "${labels[@]}"; do
    (( ${#label} > max_length )) && max_length=${#label}
done

# FIND THE X.509 CERT.PEM FILES AND POPULATE THE INDEXED ARRAY
while IFS= read -r -d '' cert_file; do
    cert_files+=("$cert_file")                    # Assign the certificate file path to the array
done < <(find "$cert_folder" -name cert.pem -print0)

# DECLARE ARRAY FOR CERTIFICATE DETAILS
certificate_info=()

# SCRAPE METADATA AND POPULATE DETAILS FOR EACH CERTIFICATE
if [ "${#cert_files[@]}" -gt 0 ]; then
    for index in "${!cert_files[@]}"; do
        cert_file="${cert_files[index]}"

        # SCRAPE X.509 CERTIFICATE METADATA USING OPENSSL
          issuer_o=$(openssl x509 -in "$cert_file" -noout -nameopt RFC2253 -issuer  | grep -o 'O=[^,]*'        | cut -d '=' -f 2)
         issuer_cn=$(openssl x509 -in "$cert_file" -noout -nameopt RFC2253 -issuer  | grep -o 'CN=[^,]*'       | cut -d '=' -f 2)
        subject_cn=$(openssl x509 -in "$cert_file" -noout -nameopt RFC2253 -subject | grep -o 'CN=[^,]*'       | cut -d '=' -f 2)
           enddate=$(openssl x509 -in "$cert_file" -noout -nameopt RFC2253 -enddate | grep -o 'notAfter=[^,]*' | cut -d '=' -f 2)

        # CALCULATE DAYS REMAINING UNTIL THE CERTIFICATE EXPIRES
        enddate_epoch=$(date -d "$enddate" +%s)
        current_epoch=$(date +%s)
        days_remaining=$(( (enddate_epoch - current_epoch) / 86400 ))

        # ADD VALUES TO CERTIFICATE INFO ARRAY
        certificate_info+=("$issuer_o" "$issuer_cn" "$subject_cn" "$enddate" "$days_remaining")
    done

    # ACCESS AND USE THE CERTIFICATE DETAILS FROM THE ARRAY
    if [ "${#certificate_info[@]}" -gt 0 ]; then
        printf "\n%s\n" "Certificate Details:"
        printf '%.0s-' {1..40}
        printf '\n'

        for index in "${!cert_files[@]}"; do
            cert_file="${cert_files[index]}"
            info_index=$((index * 5))  # Calculate the index for certificate_info array

            printf "%${max_length}s: [%d] %s\n"      "Certificate" "$((index + 1))" "$cert_file"
            printf "%${max_length}s: %s\n"           "Subject"     "${certificate_info[info_index + 2]}"
            printf "%${max_length}s: %s\n"           "Issuer"      "${certificate_info[info_index]}"
            printf "%${max_length}s: %s (%d days)\n" "Expiry"      "${certificate_info[info_index + 3]}" "${certificate_info[info_index + 4]}"
            printf '%.0s-' {1..40}
            printf '\n'
        done
    fi

    # CHECK IF CERTIFICATE EXPIRES WITHIN THRESHOLD
    cert_expiries=()
    for index in "${!certificate_info[@]}"; do
        if (( index % 5 == 3 )); then
            enddate="${certificate_info[index]}"
            enddate_epoch=$(date -d "$enddate" +%s)
            current_epoch=$(date +%s)
            days_remaining=$(( (enddate_epoch - current_epoch) / 86400 ))

            if (( days_remaining < days_threshold )); then
                exit_status=1
                cert_expiries+=("[$((index / 5 + 1))] ${cert_files[index / 5]}")  # Add certificate index number and file path to the expiring list
            fi
        fi
    done

    # FORCED EXIT STATUS SCRIPT NOTIFICATIONS
    if [[ $exit_status -ne 0 ]]; then
        printf "\n%s\n" "WARNING: Some certificates have less than $days_threshold days until expiry."
        printf "\n%s\n" "Expiring Certificates:"
        for cert in "${cert_expiries[@]}"; do
            printf " * %s\n" "$cert"
        done
    else
        printf "\n%s\n" "STATUS: All certificates have $days_threshold days or more until expiry."
    fi
    printf "\n"

else
    printf "%s\n" "No certificates found in: $cert_folder"
    exit_status=1
fi

exit "$exit_status"

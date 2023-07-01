#!/bin/bash

set -e

# Get DataDir location
DATA_DIR="/data"
case "$(ubnt-device-info firmware || true)" in
1*)
  DATA_DIR="/mnt/data"
  ;;
2*)
  DATA_DIR="/data"
  ;;
3*)
  DATA_DIR="/data"
  ;;
*)
  echo "ERROR: No persistent storage found." 1>&2
  exit 1
  ;;
esac

echo 'Installing ...'
mkdir -p "${DATA_DIR}/cronjobs"

# install pre-req
(
  cd "${DATA_DIR}/on_boot.d" && \
  curl -s https://raw.githubusercontent.com/unifi-utilities/unifios-utilities/main/on-boot-script/examples/udm-files/on_boot.d/25-add-cron-jobs.sh -O && \
  chmod +x 25-add-cron-jobs.sh && \
  echo "installed 25-add-cron-jobs.sh"
)

# install script
(
  cd "${DATA_DIR}/on_boot.d" && \
  curl -s https://raw.githubusercontent.com/opearo/udm-nat-google-dyndns-updater/main/419-google-dns-updater.sh -O && \
  chmod +x 419-google-dns-updater.sh && \
  echo "installed 419-google-dns-updater.sh"
) 

# read inputs
read -p '-> Enter Google Dynamic DNS hostname: ' hostvar
read -p '-> Enter Google Dynamic DNS generated username: ' uservar
read -sp '-> Enter Google Dynamic DNS generated password: ' passvar

echo

random_minute=$((${RANDOM} % 60))
cron_schedule="*/${random_minute} */1 * * *"
crontab_file="${DATA_DIR}/cronjobs/419-google-dns-updater"

# create crontab file
> "${crontab_file}"
printf 'GOOGLE_DNS_HOSTNAME="%s"\n' "${hostvar}" >> "${crontab_file}"
printf 'GOOGLE_DNS_TOKEN="%s"\n' "$(printf "${uservar}:${passvar}" | base64)" >> "${crontab_file}"
printf '%s root %s\n' "${cron_schedule}" "${DATA_DIR}/on_boot.d/419-google-dns-updater.sh" >> "${crontab_file}"
echo "$(basename ${crontab_file}) crontab file installed"

echo "-> Reboot your UDM to apply changes."
echo "Done."
exit 0

#!/bin/bash

# Configure variables
GOOGLE_DNS_HOSTNAME="${GOOGLE_DNS_HOSTNAME:?Require GOOGLE_DNS_HOSTNAME}"
GOOGLE_DNS_TOKEN="${GOOGLE_DNS_TOKEN:?Require GOOGLE_DNS_TOKEN}"
USER_AGENT="github.com/opearo/udm-nat-google-dyndns-updater"

# Determine if update required
current_ip="$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}')"
published_ip="$(dig +short ${GOOGLE_DNS_HOSTNAME} A)"

if [[ "${current_ip}" == "${published_ip}" ]];then
  # no update needed
  exit 0
fi

# Update Google Dynamic DNS
update_response=$(
  curl -s -H "Authorization: Basic ${GOOGLE_DNS_TOKEN}" \
	-A "${USER_AGENT}" \
	-XPOST "https://domains.google.com/nic/update" \
	-d "hostname=${GOOGLE_DNS_HOSTNAME}" \
	-d "myip=${current_ip}"
)

case "${update_response}" in
good*)
  ;&
nochg*)
  ;;
*)
  echo "ERROR: Received error response from Google DNS update: ${update_response}" 1>&2
  exit 1
  ;;
esac

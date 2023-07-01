# udm-nat-google-dyndns-updater
Update your Google domains dynamic DNS record with the Google API (even behind NAT)


## Changelog

- 2023-07-01 - added scripts

## Pre-requisites

This installation requires [UDM / UDMPro Boot Script](https://github.com/unifi-utilities/unifios-utilities/tree/main/on-boot-script)

## Compatibility

- Tested on [UDM PRO](https://store.ui.com/us/en/pro/category/all-unifi-gateway-consoles/products/udm-pro)

## Installation

SSH into the UDM/Pro/SE and run:

```shell
/bin/bash <(curl -s https://raw.githubusercontent.com/opearo/udm-nat-google-dyndns-updater/main/install.sh)
```

During installation you'll be prompted for:
- Google Dynamic DNS hostname: the hostname associated with your Google domain you want to update DNS on
- Google Dynamic DNS generated username
- Google Dynamic DNS generated password


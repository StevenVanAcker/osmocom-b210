#!/bin/sh -e

export DEBIAN_FRONTEND=noninteractive

# Following https://osmocom.org/projects/cellular-infrastructure/wiki/Latest_Builds

# setup osmocom repo
apt-get update && apt-get install -y gnupg curl lsb-release
export OSVERSION="xUbuntu_$(lsb_release -rs)"
echo "OS Version: $OSVERSION"
curl https://download.opensuse.org/repositories/network:/osmocom:/latest/$OSVERSION/Release.key | apt-key add -
echo "deb https://download.opensuse.org/repositories/network:/osmocom:/latest/$OSVERSION/ ./" > /etc/apt/sources.list.d/osmocom-latest.list


apt-get update && apt-get install -y uhd-host supervisor

OPTIONAL="osmo-hlr osmo-msc osmo-mgw osmo-stp osmo-sip-connector"
REQUIRED="osmo-trx-uhd osmo-bts-trx osmo-bsc"

apt-get install -y $REQUIRED



sed -i 's,oml remote-ip .*,oml remote-ip 127.0.0.4,' /etc/osmocom/osmo-bts-trx.cfg

cat > /etc/supervisor/conf.d/osmo-all.conf <<EOF
[program:osmo-trx-uhd]
command=/usr/bin/osmo-trx-uhd -C /etc/osmocom/osmo-trx-uhd.cfg

[program:osmo-bts-trx]
command=/usr/bin/osmo-bts-trx -c /etc/osmocom/osmo-bts-trx.cfg

[program:osmo-bsc]
command=/usr/bin/osmo-bsc -c /etc/osmocom/osmo-bsc.cfg
EOF

# This will only trigger outside a Docker container
test -e /usr/bin/systemctl && /usr/bin/systemctl restart supervisor

uhd_images_downloader


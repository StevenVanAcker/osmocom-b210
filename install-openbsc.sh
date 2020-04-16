#!/bin/sh -e

export DEBIAN_FRONTEND=noninteractive

# Following https://osmocom.org/projects/cellular-infrastructure/wiki/Latest_Builds

# setup osmocom repo
apt-get update && apt-get install -y gnupg curl lsb-release
export OSVERSION="xUbuntu_$(lsb_release -rs)"
echo "OS Version: $OSVERSION"
curl https://download.opensuse.org/repositories/network:/osmocom:/latest/$OSVERSION/Release.key | apt-key add -
echo "deb https://download.opensuse.org/repositories/network:/osmocom:/latest/$OSVERSION/ ./" > /etc/apt/sources.list.d/osmocom-latest.list


apt-get update && apt-get install -y uhd-host

PACKAGES_2G="osmo-hlr osmo-msc osmo-mgw osmo-stp osmo-bsc osmo-sip-connector osmo-trx osmo-trx-uhd"
PACKAGES=$PACKAGES_2G

apt-get install -y $PACKAGES

cat > /root/osmo-all.sh <<EOF
#!/bin/sh
cmd="\${1:-status}"
set -ex
systemctl \$cmd $PACKAGES
EOF
chmod +x /root/osmo-all.sh

uhd_images_downloader


#!/bin/bash

set -exuo pipefail

export LC_ALL=C.UTF-8
export LANG=C.UTF-8


JQ=${JQ:-jq}
XMLLINT=${XMLLINT:-xmllint}
YQ=${YQ:-yq}
UNZIP=${UNZIP:-unzip}
ARCH=$(uname -m)
QEMU_IMG=${QEMU_IMG:-qemu-img}
VIRT_FILESYSTEMS=${VIRT_FILESYSTEMS:-virt-filesystems}
GUESTFISH=${GUESTFISH:-guestfish}
DIG=${DIG:-dig}


yq_ARCH=${ARCH}
# yq and install_config.yaml use amd64 as arch for x86_64
if [ "${ARCH}" == "x86_64" ]; then
    yq_ARCH="amd64"
fi

# Download yq for manipulating in place yaml configs
if ! "${YQ}" -V; then
    if [[ ! -e yq ]]; then
        curl -L https://github.com/mikefarah/yq/releases/download/3.3.0/yq_linux_${yq_ARCH} -o yq
        chmod +x yq
    fi
    YQ=./yq
fi

if ! which ${UNZIP}; then
    sudo yum -y install /usr/bin/unzip
fi

if ! which ${JQ}; then
    sudo yum -y install /usr/bin/jq
fi

if ! which ${XMLLINT}; then
    sudo yum -y install /usr/bin/xmllint
fi

if ! which ${VIRT_FILESYSTEMS}; then
    sudo yum -y install /usr/bin/virt-filesystems
fi

if ! which ${GUESTFISH}; then
    sudo yum -y install /usr/bin/guestfish
fi

if ! which ${DIG}; then
    sudo yum -y install /usr/bin/dig
fi

if ! which ${QEMU_IMG}; then
    sudo yum -y install /usr/bin/qemu-img
fi

# The CoreOS image uses an XFS filesystem
# Beware than if you are running on an el7 system, you won't be able
# to resize the crc VM XFS filesystem as it was created on el8
if ! rpm -q libguestfs-xfs; then
    sudo yum install libguestfs-xfs
fi

# Restart the libvirt service after update
sudo systemctl restart libvirtd

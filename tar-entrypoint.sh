#!/usr/bin/env bash

set -ex

# Make sure that the group and users specified by the user exist
if ! getent group "${TAR_GID}" &>/dev/null; then
    addgroup -g "${TAR_GID}" "rsynccron"
fi
TAR_GROUP="$(getent group "${TAR_GID}" | cut -d: -f1)"

if ! getent passwd "${TAR_UID}" &>/dev/null; then
    adduser -u "${TAR_UID}" -D -H "rsynccron" -G "${TAR_GROUP}"
fi
TAR_USER="$(getent passwd "${TAR_UID}" | cut -d: -f1)"

if ! getent group "${TAR_GROUP}" | grep "${TAR_USER}" &>/dev/null; then
    addgroup "${TAR_USER}" "${TAR_GROUP}"
fi

# Setup our crontab entry
export CRONTAB_ENTRY="${TAR_CRONTAB} bash /run-tar.sh ${TAR_USER} ${TAR_GROUP}"

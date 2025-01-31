#!/usr/bin/bash

set -eux
CUSTOM_CONF_DIR="${CUSTOM_CONF_DIR:-}"
KEEPALIVED_DEFAULT_CONF='/etc/keepalived/keepalived.conf'
if [[ -z "${CUSTOM_CONF_DIR}" ]]; then
    KEEPALIVED_CONF="${KEEPALIVED_DEFAULT_CONF}"
else
    KEEPALIVED_CONF="${KEEPALIVED_DEFAULT_CONF}/keepalived.conf"
    cp "${KEEPALIVED_DEFAULT_CONF}" "${KEEPALIVED_CONF}"

fi
export assignedIP="${PROVISIONING_IP}/32"
export interface="${PROVISIONING_INTERFACE}"

sed -i "s~INTERFACE~${interface}~g" "${KEEPALIVED_CONF}"
sed -i "s~CHANGEIP~${assignedIP}~g" "${KEEPALIVED_CONF}"

exec /usr/sbin/keepalived --dont-fork --log-console \
    --pid='/run/keepalived/keepalived.pid' \
    --vrrp_pid='/run/keepalived/vrrp.pid' \
    --use-file="${KEEPALIVED_CONF}"

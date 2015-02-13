#!/bin/bash

# Read in environment variables, must come first
ENV='.env'
ROOT='/vagrant'
ENVFILE="${ROOT}/${ENV}"
[[ -f "${ENVFILE}" ]] && source "${ENVFILE}"


# Use defaults if not provided
TIMEOUT=${VPN_TIMEOUT:-60}
LOGNAME=${VPN_LOGFILE:-'vpn.log'}

LOGDIR="${ROOT}/log"
LOGFILE="${LOGDIR}/${LOGNAME}"

die() {
    echo $*
    echo "Aborting"
    exit 1
}

log() {
    echo $* >> "$LOGFILE"
}

# Make sure we're running as superuser
if [[ $(id -u) -ne 0 ]] ; then
    die "Must run this as root"
fi

# Create log directory if necessary
[[ ! -d "$LOGDIR" ]] && mkdir -p "$LOGDIR" || die "Unable to create ${LOGDIR}"

# Sanity check
if [[ -z "$VPN_USER" || -z "$VPN_PASS" || -z "$VPN_URL" ]] ; then
    die "Whoops! We can't find the required ENV variables... did you remember to set up the ${ENV} file?"
fi

# Start the VPN client, looping so we reconnect upon a disconnect.
while true ; do
    if [[ ! -f "${ROOT}/.NOVPN" ]] ; then
        log "===================================================="
        log "Starting VPN Session on $(date)"
        log "===================================================="
        echo -n "$VPN_PASS" | /usr/sbin/openconnect -u "$VPN_USER" --passwd-on-stdin "$VPN_URL" >> "$LOGFILE" 2>&1
        log "----------------------------------------------------"
        log "VPN Session Ended"
    else
        log ".NOVPN semephore exists, remove this file to activate VPN"
    fi

    log "Restarting in ${TIMEOUT} seconds..."
    sleep $TIMEOUT
done


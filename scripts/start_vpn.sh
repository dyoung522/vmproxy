#!/bin/bash

# Read in environment variables, must come first
ENVFILE='/vagrant/.env'
[[ -f "$ENVFILE" ]] && source "$ENVFILE"

# Use defaults if not provided
TIMEOUT=${VPN_TIMEOUT:-60}
LOGNAME=${VPN_LOGFILE:-'vpn.log'}
LOGFILE="/vagrant/logs/${LOGNAME}"

die() {
  echo $* | tee -a "$LOGFILE"
  echo "Aborting"
  exit 1
}

log() {
  echo $* | tee -a "$LOGFILE" 2>&1
}

# Make sure we're running as superuser
if [[ $(id -u) -ne 0 ]] ; then
  die "Must run this as root"
fi

# Create log directory if necessary
[[ ! -d $(dirname "$LOGFILE") ]] && mkdir -p $(dirname "$LOGFILE")

# Sanity check
if [[ -z "$VPN_USER" || -z "$VPN_PASS" || -z "$VPN_URL" ]] ; then
  die "Whoops! We can't find the required ENV variables... did you remember to set up the .env file?"
fi

# Start the VPN client, looping so we reconnect upon a disconnect.
while true ; do
  log "===================================================="
  log "Starting VPN Session on $(date)"
  log "===================================================="
  echo -n "$VPN_PASS" | /usr/sbin/openconnect -u "$VPN_USER" --passwd-on-stdin "$VPN_URL" >> "$LOGFILE" 2>&1
  log "----------------------------------------------------"
  log "VPN Session Ended, waiting $TIMEOUT seconds before reconnect"
  sleep $TIMEOUT
done


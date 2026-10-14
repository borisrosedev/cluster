#!/bin/bash

source log.sh

log "===================FIREWALL HANDLING =====================================" fun

result=$(sudo ufw status)
is_active=$($result | grep ": actif")
if [ -n "$is_active" ]; then
	log "UFW: active" ok
else
	log "UFW: Inactive" error
fi


log "================== END OF FIREWALL HANDLING ====================================="

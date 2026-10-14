#!/bin/bash
source log.sh

log "========================================================" fun
log "Fichiers ouverts par les processus" info
lsof -p 6443
lsof -p 10259
lsof -p  10257
lsof -p  2379
lsof -p  2380
log "========================================================" fun
log "========================================================" fun
log "Affichons les fichiers et sockets réseaux ouverts" info
lsof -i :6443
lsof -i :10259
lsof -i :10257
lsof -i :2379
lsof -i :2380
log "========================================================" fun

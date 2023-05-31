#!/bin/bash

sudo pmset -a displaysleep 15
sudo pmset -a sleep 20
sudo pmset -a disksleep 30

# Disable wake by network
sudo pmset -a womp 0
# Disable wake when power source (AC/battery) change
sudo pmset -a acwake 0
# Disable wake by other devices using the same iCloud id
sudo pmset -a proximitywake 0

# Disable TCP keepalive on sleeping, this will cause "Find My Mac" to be unavailable
sudo pmset -a tcpkeepalive 0
# Disable auto update, auto backup when sleeping
sudo pmset -a powernap 0

# Enable "full light - half light - off" screen transition, when going to sleep
sudo pmset -a halfdim 1
# Auto switch GPU for apps on battery, use separate GPU on charger
sudo pmset -b gpuswitch 2
sudo pmset -c gpuswitch 1

# Auto hibernate after a period of time of sleeping
sudo pmset -a standby 1
# High power (> `highstandbythreshold`), 2 hours hibernate
sudo pmset -a standbydelayhigh 7200
# Low power (< `highstandbythreshold`), 1 hour hibernate
sudo pmset -a standbydelaylow 3600
# Sync memory data to disk, and stop powering the memory when hibernating
sudo pmset -a hibernatemode 3
# `highstandbythreshold` defaults to 50%


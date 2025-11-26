#!/bin/bash

# Create log directory for supervisor
mkdir -p /var/log/supervisor

# Start supervisor which will manage VNC and noVNC
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

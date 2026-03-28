#!/bin/sh
# PVAccess Gateway entrypoint.
#
# Configuration is passed entirely via environment variables or a config file.
# Typical p4p.gw environment variables:
#   EPICS_PVA_ADDR_LIST    - comma/space separated upstream PVA server addresses
#   EPICS_PVA_NAME_SERVERS - name server list
#   EPICS_CA_ADDR_LIST     - upstream CA address list (when bridging CA→PVA)
#
# A config file path can be passed as the first argument:
#   docker run ... ghcr.io/infn-epics/docker-pva-gateway /config/gateway.conf
#
# Or pass any p4p.gw flags directly:
#   docker run ... ghcr.io/infn-epics/docker-pva-gateway --help
exec python -m p4p.gw "$@"

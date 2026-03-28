# ── Builder stage ────────────────────────────────────────────────────────────
# python:3.12 (full) already has gcc and the correct Python 3.12 headers,
# so epicscorelibs compiles cleanly on both amd64 and arm64.
FROM python:3.12 AS builder

RUN pip install --no-cache-dir p4p

# ── Runtime stage ─────────────────────────────────────────────────────────────
FROM python:3.12-slim

LABEL org.opencontainers.image.title="EPICS PVAccess Gateway"
LABEL org.opencontainers.image.description="PVAccess gateway powered by p4p"
LABEL org.opencontainers.image.source="https://github.com/infn-epics/docker-pva-gateway"

# Copy compiled packages and CLI tools from the builder
COPY --from=builder /usr/local/lib/python3.12/site-packages/ /usr/local/lib/python3.12/site-packages/
COPY --from=builder /usr/local/bin/pvget /usr/local/bin/pvget
COPY --from=builder /usr/local/bin/pvput /usr/local/bin/pvput
COPY --from=builder /usr/local/bin/pvinfo /usr/local/bin/pvinfo
COPY --from=builder /usr/local/bin/pvmonitor /usr/local/bin/pvmonitor

ARG USER_UID=1000
ARG GROUP_UID=1000

RUN groupadd -r epics -g "${GROUP_UID}" && \
    useradd -r -u "${USER_UID}" -g epics -d /epics -s /bin/sh epics

WORKDIR /epics

COPY start.sh /epics/start.sh
RUN chmod +x /epics/start.sh && chown -R epics:epics /epics

USER epics

ENTRYPOINT ["/epics/start.sh"]


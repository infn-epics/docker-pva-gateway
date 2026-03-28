FROM python:3.12-slim

LABEL org.opencontainers.image.title="EPICS PVAccess Gateway"
LABEL org.opencontainers.image.description="PVAccess gateway powered by p4p"
LABEL org.opencontainers.image.source="https://github.com/infn-epics/docker-pva-gateway"

# epicscorelibs (p4p transitive dep) needs gcc on arm64 — install, build, then purge
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3-dev && \
    pip install --no-cache-dir p4p && \
    apt-get purge -y gcc python3-dev && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

ARG USER_UID=1000
ARG GROUP_UID=1000

RUN groupadd -r epics -g "${GROUP_UID}" && \
    useradd -r -u "${USER_UID}" -g epics -d /epics -s /bin/sh epics

WORKDIR /epics

COPY start.sh /epics/start.sh
RUN chmod +x /epics/start.sh && chown -R epics:epics /epics

USER epics

ENTRYPOINT ["/epics/start.sh"]


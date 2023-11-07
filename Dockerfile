FROM busybox AS bin
COPY ./dist /binaries
RUN if [[ "$(arch)" == "x86_64" ]]; then \
        architecture="amd64"; \
    else \
        architecture="arm64"; \
    fi; \
    cp /binaries/nextnds-ip-updater_linux-${architecture} /bin/nextnds-ip-updater && \
    chmod +x /bin/nextnds-ip-updater && \
    chown 65532:65532 /bin/nextnds-ip-updater

FROM scratch
LABEL org.opencontainers.image.title="nextnds-ip-updater"
LABEL org.opencontainers.image.description="Simplistic container to update IP address for NextDNS - timo-reymann/nextdns-ip-updater"
LABEL org.opencontainers.image.ref.name="main"
LABEL org.opencontainers.image.licenses='MIT'
LABEL org.opencontainers.image.vendor="Timo Reymann <mail@timo-reymann.de>"
LABEL org.opencontainers.image.authors="Timo Reymann <mail@timo-reymann.de>"
LABEL org.opencontainers.image.url="https://github.com/timo-reymann/nextnds-ip-updater"
LABEL org.opencontainers.image.documentation="https://github.com/timo-reymann/nextnds-ip-updater"
LABEL org.opencontainers.image.source="https://github.com/timo-reymann/nextnds-ip-updater.git"
COPY --from=gcr.io/distroless/static-debian12:nonroot / /
USER nonroot
COPY --from=bin /bin/nextnds-ip-updater /bin/nextnds-ip-updater
ENTRYPOINT ["/bin/nextnds-ip-updater"]

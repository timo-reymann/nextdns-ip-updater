FROM busybox AS bin
COPY ./dist /binaries
RUN if [[ "$(arch)" == "x86_64" ]]; then \
        architecture="amd64"; \
    else \
        architecture="arm64"; \
    fi; \
    cp /binaries/nextdns-ip-updater_linux-${architecture} /bin/nextdns-ip-updater && \
    chmod +x /bin/nextdns-ip-updater && \
    chown 65532:65532 /bin/nextdns-ip-updater

FROM scratch
LABEL 
LABEL org.opencontainers.image.licenses="unlicense"org.opencontainers.image.title="nextdns-ip-updater"
LABEL org.opencontainers.image.description="Simplistic container to update IP address for NextDNS - timo-reymann/nextdns-ip-updater"
LABEL org.opencontainers.image.ref.name="main"
LABEL org.opencontainers.image.licenses='MIT'
LABEL org.opencontainers.image.vendor="Timo Reymann <mail@timo-reymann.de>"
LABEL org.opencontainers.image.authors="Timo Reymann <mail@timo-reymann.de>"
LABEL org.opencontainers.image.url="https://github.com/timo-reymann/nextdns-ip-updater"
LABEL org.opencontainers.image.documentation="https://github.com/timo-reymann/nextdns-ip-updater"
LABEL org.opencontainers.image.source="https://github.com/timo-reymann/nextdns-ip-updater.git"
COPY --from=gcr.io/distroless/static-debian12:nonroot / /
USER nonroot
COPY --from=bin /bin/nextdns-ip-updater /bin/nextdns-ip-updater
ENTRYPOINT ["/bin/nextdns-ip-updater"]

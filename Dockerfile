FROM alpine:latest

# Read the release version from the build args
ARG RELEASE_TAG

LABEL build="JusteReseau - Version: ${RELEASE_TAG}"
LABEL org.opencontainers.image.description="This is a docker image for Radarr, that work with Kubernetes security baselines."
LABEL org.opencontainers.image.licenses="WTFPL"
LABEL org.opencontainers.image.source="https://github.com/justereseau/Radarr"
LABEL maintainer="JusteSonic"

# Do the package update and install
RUN apk update && apk upgrade \
  && apk add --no-cache icu-libs sqlite-libs \
  && rm -rf /var/cache/apk/*

# Download and install the binary
RUN wget -O /tmp/binary.tar.gz https://github.com/Radarr/Radarr/releases/download/v${RELEASE_TAG}/Radarr.master.${RELEASE_TAG}.linux-musl-core-x64.tar.gz \
  && tar -xvzf /tmp/binary.tar.gz -C /opt \
  && rm -rf /opt/Radarr/Radarr.Update /tmp/*

# Ensure the Servarr user and group exists and set the permissions
RUN mkdir -p /config \
  && adduser -D -u 1000 -h /config servarr \
  && chown -R servarr:servarr /opt/Radarr

# Set the user
USER servarr

# Expose the port
EXPOSE 7878

# Set the command
CMD ["/opt/Radarr/Radarr", "-nobrowser", "-data=/config"]

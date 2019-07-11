FROM alpine:3.10.0

ENV DOCKER_CHANNEL=stable \
    DOCKER_VERSION=18.09.7 \
    DOCKER_COMPOSE_VERSION=1.24.1 \
    DOCKER_SQUASH=0.2.0

# Install Docker, Docker Compose, Docker Squash
RUN apk --update --no-cache add \
    bash \
    curl \
    device-mapper \
    python3 \
    py-pip \
    python3-dev \
    iptables \
    util-linux \
    openssl-dev \
    ca-certificates \
    libffi-dev \
    build-base \
    git \
    && \
    apk upgrade && \
    curl -fL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" | tar zx && \
    mv /docker/* /bin/ && chmod +x /bin/docker* && \
    pip3 install docker-compose==${DOCKER_COMPOSE_VERSION} && \
    pip3 install awscli --upgrade --user && \
    curl -fL "https://github.com/jwilder/docker-squash/releases/download/v${DOCKER_SQUASH}/docker-squash-linux-amd64-v${DOCKER_SQUASH}.tar.gz" | tar zx && \
    mv /docker-squash* /bin/ && chmod +x /bin/docker-squash* && \
    apk del build-base && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache

COPY resolv.conf /tmp/resolv.conf
COPY entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

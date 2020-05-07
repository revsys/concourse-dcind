FROM alpine:3.11 as base

ENV PATH=/.venv/bin:${PATH}

# Install Docker, Docker Compose
RUN apk add \
    bash \
    curl \
    device-mapper \
    python3 \
    py3-virtualenv \
    iptables \
    ca-certificates \
    git \
    libffi \
    util-linux \
    openssl \
    openssh-client && \
    apk upgrade

RUN apk add libgcc libstdc++ libatomic mpfr4 gmp isl mpc1

FROM base as builder

RUN python3 -m venv /.venv

RUN echo "PATH=$PATH"

ENV DOCKER_COMPOSE_VERSION 1.24.1

RUN apk add python3-dev \
    libffi-dev \
    musl-dev \
    openssl-dev \
    gcc make

RUN pip3 install docker-compose==${DOCKER_COMPOSE_VERSION} || sleep 9000

RUN pip3 install bumpversion==0.5.3 && \
    pip3 install awscli && \
    pip3 install vinnie==0.6.1


FROM base

ENV DOCKER_CHANNEL=stable \
    DOCKER_VERSION=18.09.7

ENV PATH /.venv/bin:${PATH}

RUN curl -fL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" |\
    tar --strip-components=1 -C /usr/bin -xzv

COPY resolv.conf /tmp/resolv.conf
COPY entrypoint.sh /bin/entrypoint.sh
COPY checktag.py /usr/bin/checktag
COPY --from=builder /.venv /.venv

ENV DOCKER_OPTS="--insecure-registry registry:5000 --mtu 9001"
ENV PATH /.venv/bin:${PATH}

ENTRYPOINT ["/bin/entrypoint.sh"]


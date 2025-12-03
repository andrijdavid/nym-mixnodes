ARG RUST_VER=1.91.1
ARG DEBIAN=bookworm
FROM rust:${RUST_VER}-slim-${DEBIAN} AS build
ARG VER=release/2025.4-dorina
RUN apt update -qq  && apt install -qqy pkg-config build-essential libssl-dev libudev-dev libusb-1.0-0-dev curl jq git protobuf-compiler cmake clang
RUN rustup update && \
    git clone --branch ${VER} https://github.com/nymtech/nym.git /nym
WORKDIR /nym

# Build the project following standard procedure
RUN cargo build --release

# Also build the CLI tools specifically
RUN cd tools/nym-cli && cargo build --release --locked

FROM rust:${RUST_VER}-slim-${DEBIAN}

RUN apt update -qq && apt install -qqy --no-install-recommends ca-certificates libudev1 && rm -rf /var/lib/apt/lists/* && mkdir /nym && useradd -ms /bin/bash nym
WORKDIR /home/nym
COPY --from=build /nym/target/release/nym-* /nym/
USER nym
VOLUME /home/nym/.nym/
EXPOSE 1789
EXPOSE 1790
EXPOSE 8000
EXPOSE 80
EXPOSE 443
ENTRYPOINT ["/nym/nym-node"]

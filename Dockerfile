ARG RUST_VER=1.82
ARG DEBIAN=bookworm
FROM rust:${RUST_VER}-slim-${DEBIAN} as build
ARG VER=main
RUN apt update -qq  && apt install -qqy pkg-config build-essential libssl-dev curl jq git protobuf-compiler cmake clang
RUN rustup update && \
    git clone --branch ${VER} --depth 1 https://github.com/nymtech/nym.git /nym
WORKDIR /nym 
RUN cargo build --release --workspace --locked
RUN cd /nym/tools/nym-cli && cargo build --release --locked

FROM rust:${RUST_VER}-slim-${DEBIAN}

RUN apt update -qq && apt install -qqy --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/* && mkdir /nym && useradd -ms /bin/bash nym
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

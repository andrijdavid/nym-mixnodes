ARG RUST_VER=1.64
FROM rust:${RUST_VER}-slim-buster as build
ARG VER=1.0.2
RUN apt update -qq  && apt install -qqy pkg-config build-essential libssl-dev curl jq git
RUN rustup update && git clone https://github.com/nymtech/nym.git  /nym
WORKDIR /nym 
RUN git checkout tags/nym-binaries-$VER && cargo build --release

FROM rust:${RUST_VER}-slim-buster
RUN mkdir /nym && useradd -ms /bin/bash nym
WORKDIR /home/nym
COPY --from=build /nym/target/release/nym-mixnode /nym/
USER nym
VOLUME /home/nym/.nym/
EXPOSE 1789
EXPOSE 1790
EXPOSE 8000
EXPOSE 80
EXPOSE 443
ENTRYPOINT ["/nym/nym-mixnode"]
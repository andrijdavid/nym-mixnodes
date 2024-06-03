ARG RUST_VER=1.66
ARG DEBIAN=bullseye
FROM rust:${RUST_VER}-slim-${DEBIAN} as build
ARG VER=1.1.1
RUN apt update -qq  && apt install -qqy pkg-config build-essential libssl-dev curl jq git
RUN rustup update && git clone https://github.com/nymtech/nym.git  /nym
WORKDIR /nym 
RUN git checkout release/v$VER && cargo build --release

FROM rust:${RUST_VER}-slim-${DEBIAN}
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
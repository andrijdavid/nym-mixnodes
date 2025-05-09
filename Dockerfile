ARG RUST_VER=1.86
ARG DEBIAN=bookworm
FROM rust:${RUST_VER}-slim-${DEBIAN} as build
ARG VER=nym-binaries-v2025.8-tourist
RUN apt update -qq  && apt install -qqy pkg-config build-essential libssl-dev curl jq git
RUN rustup update && git clone https://github.com/nymtech/nym.git  /nym
WORKDIR /nym 
RUN git checkout $VER && cargo build --release
RUN cd /nym/tools/nym-cli && cargo build --release

FROM rust:${RUST_VER}-slim-${DEBIAN}

RUN apt update -qq && apt install -qqy --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/* && mkdir /nym && useradd -ms /bin/bash nym
WORKDIR /home/nym
COPY --from=build /nym/target/release/nym-api /nym/
COPY --from=build /nym/target/release/nym-authenticator /nym/
COPY --from=build /nym/target/release/nym-cli /nym/
COPY --from=build /nym/target/release/nym-client /nym/
COPY --from=build /nym/target/release/nym-credential-proxy /nym/
COPY --from=build /nym/target/release/nym-data-observatory /nym/
COPY --from=build /nym/target/release/nym-ip-packet-router /nym/
COPY --from=build /nym/target/release/nym-node /nym/
COPY --from=build /nym/target/release/nym-node-status-api /nym/
COPY --from=build /nym/target/release/nym-network-requester /nym/
COPY --from=build /nym/target/release/nym-socks5-client /nym/
COPY --from=build /nym/target/release/nym-validator-rewarder /nym/
COPY --from=build /nym/target/release/nymvisor /nym/

COPY --from=build /nym/target/release/nym-validator-rewarder /nym/
USER nym
VOLUME /home/nym/.nym/
EXPOSE 1789
EXPOSE 1790
EXPOSE 8000
EXPOSE 80
EXPOSE 443
ENTRYPOINT ["/nym/nym-node"]

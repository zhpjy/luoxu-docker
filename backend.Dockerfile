FROM ubuntu AS builder-image
# avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y git python3 python3-dev python3-pip build-essential opencc wget libopencc-dev pkg-config && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# install rust
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
	PKG_CONFIG_PATH==/usr/lib/pkgconfig

RUN set -eux; \
    url="https://sh.rustup.rs"; \
    wget -O rustup-init "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain nightly --profile minimal; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

RUN ls -alht /build; \
	git clone --depth 1 -b master https://github.com/lilydjwg/luoxu.git /build; \
	cd /build/querytrans; \
	cargo build --release

FROM ubuntu AS runner-image

COPY --from=builder-image /build /app

WORKDIR /app/luoxu

RUN apt-get update && apt-get install -y python3 pip libpython3-dev opencc &&\
	apt-get clean && rm -rf /var/lib/apt/lists/* &&\
    pip install --no-cache-dir -r /app/requirements.txt && pip install PySocks tomli

# make sure all messages always reach console
ENV PYTHONUNBUFFERED=1

EXPOSE 9008


CMD ["/usr/bin/python3","-m", "luoxu"]


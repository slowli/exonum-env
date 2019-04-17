FROM exonum-env AS builder
ARG EXONUM_REV=v0.11.0
RUN apt-get install -y --no-install-recommends git && \
  cargo install \
    --root /usr/local \
    --git https://github.com/exonum/exonum.git \
    --rev $EXONUM_REV \
    --example demo \
    exonum-cryptocurrency

FROM exonum-prod
COPY --from=builder /usr/local/bin/demo /usr/bin/cryptocurrency
CMD ["cryptocurrency"]

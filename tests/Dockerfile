# syntax=docker/dockerfile:experimental
FROM exonum-env AS builder
ARG EXONUM_REV=v0.11.0
# Cache mounts do not make a difference during CI builds (there is no good way so far
# to extract cache mounts from the Docker server), but they could greatly speed up
# the build in a controlled environment.
RUN --mount=type=cache,id=cargo,target=/cargo \
  --mount=type=cache,id=artifacts,target=/target \
  mkdir -p /cargo/git && \
  mkdir -p /cargo/registry && \
  cargo install \
    --root /usr/local \
    --git https://github.com/exonum/exonum.git \
    --rev $EXONUM_REV \
    --example demo \
    exonum-cryptocurrency

FROM exonum-prod
COPY --from=builder /usr/local/bin/demo /usr/bin/cryptocurrency
CMD ["cryptocurrency"]

# Docker image for hosting Exonum apps

This Docker image, `slowli/exonum-prod`, allows to host Exonum apps.
The image does not contain Exonum itself, but rather shared libraries
necessary to run a reasonable majority of Exonum apps:

- RocksDB (+ compression libs)
- libsodium
- Protobuf

This is a small(ish) production image, which does not contains tools for
development (e.g., Rust). Thus, it should be used as a final image in
[multi-stage builds][docker-multistage].

[docker-multistage]: https://docs.docker.com/develop/develop-images/multistage-build/

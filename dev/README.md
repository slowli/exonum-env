# Docker image for quickly testing Exonum apps

This Docker image, `slowli/exonum-env`, allows to quickly deploy or test Exonum apps.
The image does not contain Exonum itself (it's a library), but rather dependencies
necessary to build a reasonable majority of Exonum apps, such as Rust, RocksDB, libsodium
and Protobuf. The image is based on Ubuntu 16.04 Xenial. It contains one of the latest
stable Rust toolchains. Docker tags for the image are based on the packaged Rust toolchain.

Because of large size, this image is more fitting for use as a building container
(e.g., in [multistage builds][docker-multistage]) than as a final image for an Exonum app.

## Using in testing

### Create a container

Create a container from the image. The container should use
[volumes][docker-volume] or [bind mounts][docker-mount] for the following directories:

- `/project`: This is where the workspace with the source code should be placed.
  (The directory may include `target` dir; the container won't touch it.)
- `/target`: This is where the `cargo build`, `cargo test`, etc. will place artifacts.
  Thus, the volume mounted here should be different for different workspaces.
- `/cargo`: This dir will contain Cargo cache (mainly the source code of crates). The
  mounted volume may be shared among workspaces.

Volumes are generally preferable to bind mounts as they are more reliable. In particular,
binding `/target` to a dir on the Windows host can make Cargo restart builds from scratch
every time.

#### Example

Suppose we want to test the project at `/my/precious/project`, with the Cargo cache volume
being named `cargo-cache` and the volume for project artifacts named `precious-target`.
(Note that volumes can be created automatically on the first launch.) The corresponding CLI
command to create the container will look as follows:

```bash
docker run -it \
  -v /my/precious/project:/project:ro \
  -v cargo-cache:/cargo \
  -v precious-target:/target \
  --name precious \
  slowli/exonum-env:latest \
  bash
```

### Attach to the container

To run commands within the container (e.g., Cargo tests), you can
[attach to it][docker-attach] via

```bash
docker attach $name
```

where `$name` is the container name.

### Expose ports

To expose container ports (e.g., HTTP API addresses of an Exonum node),
start the container with [the `-p` flag][docker-expose].
Note that the server in the container should bind to an externally visible
interface (e.g., `0.0.0.0`).

## Using as a builder

The image can be used in multistage builds as a heavyweight builder.
It is especially efficient to bind `/cargo` and `/target` mounting points
to [cache mounts][buildkit-cache] available in Docker 18.09+:

```dockerfile
# syntax=docker/dockerfile:experimental
FROM slowli/exonum-env:latest AS builder

RUN --mount=type=cache,id=cargo,target=/cargo \
  --mount=type=cache,id=artifacts,target=/target \
  cargo install \
    --root /usr/local \
    --version $version_of_your_crate \
    $your_exonum_crate

FROM slowli/exonum-prod:latest
COPY --from=builder /usr/local/bin/* /usr/bin/
```

Instead of installing from crates.io, you may want to install from git for finer-grained control
or privacy reasons; see [`cargo install` docs][cargo-install] for more details.
Note that experimental Docker features include [SSH forwarding][buildkit-ssh],
which is useful for building from a private git repo.

[docker-volume]: https://docs.docker.com/storage/volumes/
[docker-mount]: https://docs.docker.com/storage/bind-mounts/
[docker-attach]: https://docs.docker.com/engine/reference/commandline/attach/
[docker-expose]: https://docs.docker.com/engine/reference/commandline/run/#publish-or-expose-port--p---expose
[docker-multistage]: https://docs.docker.com/develop/develop-images/multistage-build/
[buildkit-cache]: https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/experimental.md#run---mounttypecache
[cargo-install]: https://doc.rust-lang.org/cargo/commands/cargo-install.html
[buildkit-ssh]: https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/experimental.md#run---mounttypessh

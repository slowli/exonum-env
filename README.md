# Docker image for quickly testing Exonum apps

This Docker image, `slowli/exonum-env`, allows to quickly deploy or test Exonum apps.
The image does not contain Exonum itself (it's a library), but rather dependencies
necessary to build a reasonable majority of Exonum apps, such as Rust, RocksDB, libsodium
and Protobuf.

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

[docker-volume]: https://docs.docker.com/storage/volumes/
[docker-mount]: https://docs.docker.com/storage/bind-mounts/
[docker-attach]: https://docs.docker.com/engine/reference/commandline/attach/
[docker-expose]: https://docs.docker.com/engine/reference/commandline/run/#publish-or-expose-port--p---expose

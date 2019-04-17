# Docker images for Exonum

- [dev](dev) corresponds to the [`slowli/exonum-env` image](https://hub.docker.com/r/slowli/exonum-env).
  This is an image for compiling or testing Exonum apps.
- [prod](prod) corresponds to the [`slowli/exonum-prod` image](https://hub.docker.com/r/slowli/exonum-prod).
  This is an image for running Exonum apps (possibly compiled with the help of the previous image)

## Usage

See an [example Dockerfile](tests/Dockerfile) in the `tests` directory to learn how both images can be used
in multi-stage builds.

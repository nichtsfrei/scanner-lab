# Slackware test image

This image is used to verify gather-packagelist of openvas as well as notus.

It runs an ssh service on port 22 with the login credentials: `gvm:gvm`.

To get all installed packages so that you can create your own product definitions you can execute:
```
make gather-packagelist
```

this does create a `packages.lst` file containing all installed packages within the slackware image.


## How to build

To build a new image you need to have `docker` installed and configured as well as `gnu-make`.

To build a new image you can execute:

```
make build
```

## How to import into k3s

WARNING: this requires sudo and an interactive terminal.

If you're running k3s without a docker backend then you can execute:

```
make import-into-k3s
```

to build and import a new image of slackware into k3s.



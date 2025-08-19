# Automation for building CML Docker Containers

This repository contains the automation and scripts to build the Docker
container images, node definition and image definitions which are included in
the Cisco Modeling Labs product.

In addition, there are two node definitions which are not included:

- **IOS XRd** [Binary IOS XRd images can be downloaded here](https://software.cisco.com/download/home/286331236/type).
- **Netflow** This requires a very old Debian distro, the netflow package has
disappeared in newer Debian distros.

## Dependencies

For this to work, it is recommended to run this inside of a Ubuntu or Debian VM
with development packages and Docker installed. In particular

- Docker <https://docs.docker.com/engine/install/ubuntu/> or <https://docs.docker.com/engine/install/debian/>
- dpkg-dev
- devscripts

If no Debian package should be built, then only `make` is required which can be
installed using `apt install make`.

## Building

Either run `make` at the top level to build all container images and the
associated node and image definitions. Or `cd` into a specific directory and
run `make` there.

> [!NOTE]
> netflow and IOS XRd are "off" by default. To turn either of them "on", rename
> the Dockerfile in the respective directory, removing the "-off" part from the
> filename.

## Results

The files are built in the `BUILD/debian/refplat-images-docker/...` directory.
Copy the resulting node and image definitions to your CML server into the same
place `/var/lib/libvirt/images/...`.

As an option, a Debian package can be built which can also be installed on the
CML server. The package build process can be started via `make deb` and
requires the aforementioned dev tools and scripts installed.

## Specific note on XRd

The file that can be downloaded from CCO is e.g.
`xrd-control-plane-container-x86.24.4.2.tgz` for version 24.4.2. This is a
tar/gz archive which includes the actual Docker image. Put the downloaded file
into the `xrd` directory, make sure the version matches what is defined in the
`vars` file. The process will then extract the needed image file from the
archive and process it.

# local-debian

Make a local debian base image to be used for Docker

Building locally means we can trust the thing much more than stuff downloaded by docker hub

Additionally because we are building from scratch this theoretically should work on any platform debian runs on

### Manually

This should be as simple as passing an argument (release) that is equal to the distro of debian you want e.g.

```
./local-debian.sh --release=jessie
```

### Makefile

You can also use the Makefile

```
make jessie
```

There is also a stretch recipe i.e.
```
make stretch
```

### Removal

to remove the image

```
make rmjessie
```

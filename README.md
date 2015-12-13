# local-debian

Make a local debian base image to be used for Docker

Building locally means we can trust the thing much more than stuff downloaded by docker hub

Additionally because we are building from scratch this theoretically should work on any platform debian runs on

This should be as simple as

```
./local-jessie.sh
```

### Makefile

You can also use the Makefile

```
make jessie
```

to remove the image

```
make rmjessie
```

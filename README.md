# Docker container to build a Go project with gb

Simple container to build a [Go](http://golang.org) project using [gb](http://getgb.io) with source on the host. Uses volumes to mount a host directory as the project directory in container.

## Build project in current working directory
1. Make changes to Go code
1. Start go-gb container and use current directory as source for build

    `$ docker run --rm -v=${PWD}:/home/builder/project memes/go-gb:1.5-v0.2.0`

3. Docker will launch the container, mount current directory as volume and build the application with gb. Compiled output will be in `/bin`

## Cross-compile current project
Same as above, but pass GOOS and GOARCH variables to create a `.exe` in `bin/`

`$ docker run --rm -e GOOS=windows -e GOARCH=amd64 -v=${PWD}:/home/builder/project memes/go-gb:1.5-v0.2.0`

## Want to force a reset of gb vendor directory?
You should take care of that in local copy before invoking container, but it can be forced. Set the env var `GO_GB_RESTORE` to non-empty and a `gb vendor restore` will be executed before the build.

## You say you need to add ldflags or conditional tags? Something more exotic?
Just like the cross-compile example, all supported Go build environment variables can be assigned by `docker run -e ...` invocation.

Additional flags can be passed to `go build` by using `GO_GB_FLAGS` variable.
E.g. `docker run -e GO_GB_FLAGS="-tags prod" ...` will execute `gb build -tags prod`

## Need SSH support for repos?
Add the keys to /home/builder/.ssh and make any necessary changes to .gitconfig

Clone the github repo [go-gb](https://github.com/memes/go-gb.git) to customise further.

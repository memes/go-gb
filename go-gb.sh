#!/bin/sh
#
# Wrapper script to build Go project in current working directory with gb
#
# If GO_GB_RESTORE environment is not empty, request that gb restore the vendor
# directory from manifest
[ -n "${GO_GB_RESTORE}" -a -r vendor/manifest ] && gb vendor restore

# Execute the build; additional go flags can be provided via GO_GB_FLAGS.
# NOTE: standard Go environment vars can still be passed into container for
# cross-compilation etc
gb build ${GO_GB_FLAGS}

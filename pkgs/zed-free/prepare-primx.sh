#!/bin/sh

# this is mostly a rip-off from the debian package postinst

ACCESS_FILES_PATH=/tmp/primx/accessfiles
ALL_USERS_REGISTRY=/tmp/primx/users.registry

mkdir -p ${ACCESS_FILES_PATH} ; chmod 1777 ${ACCESS_FILES_PATH}
touch $ALL_USERS_REGISTRY
chmod 666 $ALL_USERS_REGISTRY

#!/usr/bin/env sh
#
# This script starts the redis-cluster vm
#
export QEMU_NET_OPTS="hostfwd=tcp::2222-:22,hostfwd=tcp::7000-:7000,hostfwd=tcp::7001-:7001,hostfwd=tcp::7002-:7002,hostfwd=tcp::7003-:7003,hostfwd=tcp::7004-:7004,hostfwd=tcp::7005-:7005"
./result/bin/run-redis-cluster-vm

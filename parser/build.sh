#!/bin/bash

pushd libdparse
dub build --compiler=ldc
popd
ldc -g -Ilibdparse/src/ -Ilibdparse/experimental_allocator/src/ -shared src/dparse.d libdparse/libdparse.a

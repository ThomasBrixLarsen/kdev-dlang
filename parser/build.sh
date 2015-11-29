#!/bin/bash

pushd libdparse
dub build --compiler=ldc
popd
ldc -g -Ilibdparse/src -Ilibdparse/experimental_allocator/src/ cppwrappergenerator.d libdparse/libdparse.a
./cppwrappergenerator libdparse/src/dparse/ast.d > src/astWrapper.d
./cppwrappergenerator libdparse/src/dparse/ast.d -h > dparser.h
ldc -g -Ilibdparse/src/ -Ilibdparse/experimental_allocator/src/ -shared src/dparse.d src/astWrapper.d libdparse/libdparse.a

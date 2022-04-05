#!/bin/bash

mkdir -p .build/symbol-graphs

rm -rf .build/symbol-graphs/* || true

swift build --target Hooks \
    -Xswiftc -emit-symbol-graph \
    -Xswiftc -emit-symbol-graph-dir -Xswiftc .build/symbol-graphs

mkdir .build/swift-docc-symbol-graphs

rm -rf .build/swift-docc-symbol-graphs/* || true

mv .build/symbol-graphs/Hooks* .build/swift-docc-symbol-graphs/

#!/bin/bash

swift run docc preview Sources/SwiftHooks/Documentation.docc \
  --fallback-display-name SwiftHooks \
  --fallback-bundle-identifier com.intuit.hooks \
  --fallback-bundle-version 1.0.0 \
  --additional-symbol-graph-dir .build/swift-docc-symbol-graphs
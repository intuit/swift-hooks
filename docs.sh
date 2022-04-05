#!/bin/bash

swift run docc convert Sources/SwiftHooks/Documentation.docc \
  --fallback-display-name SwiftHooks \
  --fallback-bundle-identifier com.intuit.hooks \
  --additional-symbol-graph-dir .build/swift-docc-symbol-graphs \
  --output-path SwiftHooks.doccarchive \
  --hosting-base-path swift-hooks

swift run docc process-archive transform-for-static-hosting SwiftHooks.doccarchive
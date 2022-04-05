#!/bin/bash

swift run docc convert Sources/SwiftHooks/Documentation.docc \
  --fallback-display-name SwiftHooks \
  --fallback-bundle-identifier com.intuit.hooks \
  --additional-symbol-graph-dir .build/swift-docc-symbol-graphs \
  --output-path SwiftHooks.doccarchive

swift run docc process-archive transform-for-static-hosting --hosting-base-path swift-hooks SwiftHooks.doccarchive
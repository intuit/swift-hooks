#!/bin/bash

swift run docc convert Sources/Hooks/Documentation.docc \
  --fallback-display-name Hooks \
  --fallback-bundle-identifier com.intuit.hooks \
  --additional-symbol-graph-dir .build/swift-docc-symbol-graphs \
  --output-path Hooks.doccarchive \
  --hosting-base-path swift-hooks

swift run docc process-archive transform-for-static-hosting Hooks.doccarchive
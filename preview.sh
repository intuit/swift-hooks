#!/bin/bash

swift run docc preview Sources/Hooks/Documentation.docc \
  --fallback-display-name Hooks \
  --fallback-bundle-identifier com.intuit.hooks \
  --fallback-bundle-version 1.0.0 \
  --additional-symbol-graph-dir .build/swift-docc-symbol-graphs
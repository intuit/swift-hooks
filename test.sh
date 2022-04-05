#!/bin/sh

swift test --parallel --enable-code-coverage

BIN_PATH="$(swift build --show-bin-path)"
XCTEST_PATH="$(find ${BIN_PATH} -name '*.xctest')"

COV_BIN=$XCTEST_PATH
# if [[ "$OSTYPE" == "darwin"* ]]; then
#     f="$(basename $XCTEST_PATH .xctest)"
#     COV_BIN="${COV_BIN}/Contents/MacOS/$f"
# fi

llvm-cov export \
    --instr-profile=.build/debug/codecov/default.profdata \
    --ignore-filename-regex=".build|Tests|ExampleLibrary" \
    --format=lcov \
    "${COV_BIN}" \
    > .build/reports/coverage.lcov
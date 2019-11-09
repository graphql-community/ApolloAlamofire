#/bin/bash

set -e 
set -o pipefail

xcodebuild test -enableCodeCoverage YES \
    -workspace Example/ApolloAlamofire.xcworkspace -scheme Example \
    -sdk iphonesimulator -destination "$TEST_DEVICE" | xcpretty
pod repo update
pod lib lint --allow-warnings

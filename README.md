# SwiftCrypto

[SwiftCrypto](https://github.com/apple/swift-crypto) with backwards deployment support. Support macOS 10.10 / iOS 8.0 / tvOS 9.0 / watchOS 2.0.

## Usage

For backwards deployment, set environment variable `SWIFT_CRYPTO_BACK_DEPLOY`.

```
$ export SWIFT_CRYPTO_BACK_DEPLOY="YES"

# for CLI tools, execute with env variable
$ swift ...
$ xcodebuild ...

# for Xcode GUI, reopen Xcode with env variable
$ killall Xcode
$ open Package.swift
```


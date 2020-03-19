// swift-tools-version:5.1
//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftCrypto open source project
//
// Copyright (c) 2019 Apple Inc. and the SwiftCrypto project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftCrypto project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

// This package contains a vendored copy of BoringSSL. For ease of tracking
// down problems with the copy of BoringSSL in use, we include a copy of the
// commit hash of the revision of BoringSSL included in the given release.
// This is also reproduced in a file called hash.txt in the
// Sources/CCryptoBoringSSL directory. The source repository is at
// https://boringssl.googlesource.com/boringssl.
//
// BoringSSL Commit: 0416e8c3055c7fcfd6c3eab4c127a36df1e6097b

import PackageDescription
import Foundation

let env = ProcessInfo.processInfo.environment
let backDeployKey = "SWIFT_CRYPTO_BACK_DEPLOY"
let isBackDeploy = (env[backDeployKey] as NSString?)?.boolValue == true

var swiftSettings: [SwiftSetting] = [
    .define("CRYPTO_IN_SWIFTPM"),
]
let platforms: [SupportedPlatform]

swiftSettings += [.define("CRYPTO_IN_SWIFTPM_FORCE_BUILD_API")]
platforms = [
    .macOS(.v10_10),
    .iOS(.v8),
    .watchOS(.v2),
    .tvOS(.v9),
]

let package = Package(
    name: "swift-crypto",
    platforms: platforms,
    products: [
        .library(name: "Crypto", targets: ["Crypto"]),
        /* This target is used only for symbol mangling. It's added and removed automatically because it emits build warnings. MANGLE_START
            .library(name: "CCryptoBoringSSL", type: .static, targets: ["CCryptoBoringSSL"]),
            MANGLE_END */
    ],
    dependencies: [],
    targets: [
        .target(name: "CCryptoBoringSSL"),
        .target(name: "CCryptoBoringSSLShims", dependencies: ["CCryptoBoringSSL"]),
        .target(name: "Crypto", dependencies: ["CCryptoBoringSSL", "CCryptoBoringSSLShims"], swiftSettings: swiftSettings),
        .target(name: "crypto-shasum", dependencies: ["Crypto"]),
        .testTarget(name: "CryptoTests", dependencies: ["Crypto"], swiftSettings: swiftSettings),
    ],
    cxxLanguageStandard: .cxx11
)

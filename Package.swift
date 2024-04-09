// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "LoggingViewKit",
                      platforms: [.iOS(.v13), .macOS(.v10_15)],
                      products: [// Products define the executables and libraries a package
                          // produces, and make them visible to other packages.
                          .library(name: "LoggingViewKit",
                                   targets: ["LoggingViewKit"])],
                      dependencies: [// Dependencies declare other packages that this package
                          // depends on.
                          // .package(url: /* package url */, from: "1.0.0"),
                      ],
                      targets: [// Targets are the basic building blocks of a package. A target can
                          // define a module or a test suite.
                          // Targets can depend on other targets in this package, and on products in
                          // packages this package depends on.
                          .binaryTarget(name: "LoggingViewKit",
                                        url: "https://github.com/HituziANDO/LoggingViewKit/blob/6.0.2/Frameworks/LoggingViewKit.xcframework.zip",
                                        checksum: "e7c28e12497199331e76af422922132a6ba915cb0f524d58ffae370987d943bb")])

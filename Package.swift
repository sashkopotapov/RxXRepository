// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RxXRepository",
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "RxXRepository",
      targets: ["RxXRepository"])
//
//    .library(
//      name: "RxXRepositoryUserDefaults",
//      targets: ["RxXRepositoryUserDefaults"])
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/sashkopotapov/XRepository.git", from: "1.1.0"),
    .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.0.0")
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "RxXRepository",
      dependencies: [
        .product(name: "XRepository", package: "XRepository"),
        .product(name: "RxSwift", package: "RxSwift"),
        .product(name: "RxCocoa", package: "RxSwift")
      ]),
    
//    .target(
//      name: "RxXRepositoryUserDefaults",
//      dependencies: [
//        "RxXRepository",
//        .product(name: "XRepository", package: "XRepository"),
//        .product(name: "XRepositoryUserDefaults", package: "XRepository"),
//        .product(name: "RxSwift", package: "RxSwift"),
//        .product(name: "RxCocoa", package: "RxSwift")
//      ])
  ]
)

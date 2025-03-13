// swift-tools-version: 6.1

import Foundation // for String.capitalized
import PackageDescription

_ = Package(
  name: .shortenedName(),
  platforms: [.iOS(.v13), .macOS(.v10_15)],
  products: [.library(name: .shortenedName(), targets: [.shortenedName()])],
  dependencies: dependencies.map(\.package),
  targets: [
    .target(
      name: .shortenedName(),
      dependencies: dependencies.dropFirst().map(\.product)
    ),
    .testTarget(
      name: .shortenedName(suffix: "Tests"),
      dependencies: [.init(stringLiteral: .shortenedName())]
    )
  ]
)

extension String {
  static func shortenedName(suffix: String? = nil) -> String {
    let shortenedName = "Thrappture"
    return if let suffix { "\(shortenedName).\(suffix)" }
    else { shortenedName }
  }
}

// MARK: - Dependency

nonisolated var dependencies: [Dependency]  {
  [ .swift(repositoryName: "docc-plugin")
  ]
}

struct Dependency {
  let package: Package.Dependency
  let product: Target.Dependency
}

extension Dependency {
  static func apple(repositoryName: String) -> Self {
    .swift(organization: "apple", repositoryName: repositoryName)
  }

  static func swift(organization: String = "swiftlang", repositoryName: String) -> Self {
    .init(
      organization: organization,
      name: repositoryName.split(separator: "-").map(\.capitalized).joined(),
      repositoryName: "swift-\(repositoryName)"
    )
  }

  static func catterwaul(name: String, repositoryName: String? = nil, branch: String? = nil) -> Self {
    .init(
      organization: "Catterwaul",
      name: name,
      repositoryName: repositoryName ?? name,
      branch: branch
    )
  }

  private init(organization: String, name: String, repositoryName: String, branch: String? = nil) {
    self.init(
      package: .package(
        url: "https://github.com/\(organization)/\(repositoryName)",
        branch: branch ?? "main"
      ),
      product: .product(name: name, package: repositoryName)
    )
  }
}

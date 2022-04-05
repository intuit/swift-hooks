<div align="center">
  <img
    src="Sources/SwiftHooks/Documentation.docc/Resources/Images/hooks@2x.png"
    alt="SwiftHooks Logo"
    width="300px"
    padding="40px"
  />
  <br />
  <br />
  <p>SwiftHooks is a little module for plugins, in Swift</p>
</div>

---

A `Hook` represents a "pluggable" point in a software model. They provide a mechanism for "tapping" into such points to get updates, or apply additional functionality to some typed object.

### Variety of built in hook types
| Type | Behavior |
|------|----------|
| Basic | Executes the taps with no return value |
| Waterfall | "Reduce" the result through all the taps |
| Bail | Retrieve the result of the first tap that handles the calling value |
| Loop | Execute taps until no taps request the loop be restarted |

## Inspiration

At Intuit, we're big fans of [tapable](https://github.com/webpack/tapable), and plugin architecture. This package is the Swift companion to the Kotlin [hooks](https://github.com/intuit/hooks/). These are packages we use to enable extensible software, keeping extensions isolated to those that need them, avoiding bloat in primary projects.

## Installation

#### Swift Package Manager

Install with [Swift Package Manager](https://www.swift.org/package-manager/) by adding a reference to your `Package.swift` dependencies:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/intuit/swift-hooks.git", from: "0.0.1")
    ]
)
```

#### CocoaPods

Install with [CocoaPods](https://cocoapods.org/) by adding an entry to your `Podfile`, and then running `pod install`:

```ruby
pod 'SwiftHooks'
```

## Structure

- [SwiftHooks](https://github.com/intuit/swift-hooks/tree/main/Sources/SwiftHooks) - The SwiftHooks implementation
- [ExampleLibrary](https://github.com/intuit/swift-hooks/tree/main/Sources/ExampleLibrary) - An example usage of SwiftHooks

## Contributing

Feel free to make an [issue](https://github.com/intuit/swift-hooks/issues) if you are having trouble or open a [pull request](https://github.com/intuit/swift-hooks/pulls) if you have an improvement to add!

Make sure to read our [code of conduct](./.github/CODE_OF_CONDUCT.md).

### Build
This is a Swift only package, so it can be built easily from the command line:
```bash
swift build
```

### Test
Running tests in parallel is preffered as it completes much faster:
```bash
swift test --parallel
```

### Lint
This project uses [SwiftLint](https://github.com/realm/SwiftLint) for linting, and follows the default conventions:
```bash
swift run swiftlint
```

#### Formatting
This project is also set up for [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) to automatically format code:
```bash
swift run swiftformat Sources
```

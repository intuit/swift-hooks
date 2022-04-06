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
<div align="center">
<a href="https://github.com/intuit/auto"><img src="https://img.shields.io/badge/release-auto.svg?colorA=888888&colorB=9B065A&label=auto&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAACzElEQVR4AYXBW2iVBQAA4O+/nLlLO9NM7JSXasko2ASZMaKyhRKEDH2ohxHVWy6EiIiiLOgiZG9CtdgG0VNQoJEXRogVgZYylI1skiKVITPTTtnv3M7+v8UvnG3M+r7APLIRxStn69qzqeBBrMYyBDiL4SD0VeFmRwtrkrI5IjP0F7rjzrSjvbTqwubiLZffySrhRrSghBJa8EBYY0NyLJt8bDBOtzbEY72TldQ1kRm6otana8JK3/kzN/3V/NBPU6HsNnNlZAz/ukOalb0RBJKeQnykd7LiX5Fp/YXuQlfUuhXbg8Di5GL9jbXFq/tLa86PpxPhAPrwCYaiorS8L/uuPJh1hZFbcR8mewrx0d7JShr3F7pNW4vX0GRakKWVk7taDq7uPvFWw8YkMcPVb+vfvfRZ1i7zqFwjtmFouL72y6C/0L0Ie3GvaQXRyYVB3YZNE32/+A/D9bVLcRB3yw3hkRCdaDUtFl6Ykr20aaLvKoqIXUdbMj6GFzAmdxfWx9iIRrkDr1f27cFONGMUo/gRI/jNbIMYxJOoR1cY0OGaVPb5z9mlKbyJP/EsdmIXvsFmM7Ql42nEblX3xI1BbYbTkXCqRnxUbgzPo4T7sQBNeBG7zbAiDI8nWfZDhQWYCG4PFr+HMBQ6l5VPJybeRyJXwsdYJ/cRnlJV0yB4ZlUYtFQIkMZnst8fRrPcKezHCblz2IInMIkPzbbyb9mW42nWInc2xmE0y61AJ06oGsXL5rcOK1UdCbEXiVwNXsEy/6+EbaiVG8eeEAfxvaoSBnCH61uOD7BS1Ul8ESHBKWxCrdyd6EYNKihgEVrwOAbQruoytuBYIFfAc3gVN6iawhjKyNCEpYhVJXgbOzARyaU4hCtYizq5EI1YgiUoIlT1B7ZjByqmRWYbwtdYjoWoN7+LOIQefIqKawLzK6ID69GGpQgwhhEcwGGUzfEPAiPqsCXadFsAAAAASUVORK5CYII=" alt="Auto Release" /></a>
<a href="https://circleci.com/gh/intuit/swift-hooks"><img alt="CircleCI" src="https://img.shields.io/circleci/build/github/intuit/swift-hooks"></a>
<img alt="Cocoapods" src="https://img.shields.io/cocoapods/v/SwiftHooks">
<img alt="License" src="https://img.shields.io/cocoapods/l/SwiftHooks">
<img alt="GitHub top language" src="https://img.shields.io/github/languages/top/intuit/swift-hooks?logo=swift">
<a href="https://intuit.github.io/swift-hooks/documentation/swifthooks/"><img alt="GitHub Pages" src="https://img.shields.io/badge/docs-pages-green"/></a>
</div>

A `Hook` represents a "pluggable" point in a software model. They provide a mechanism for "tapping" into such points to get updates, or apply additional functionality to some typed object.

### Variety of built in hook types
| Type | Behavior |
|------|----------|
| Basic | Executes the taps with no return value |
| Waterfall | "Reduce" the result through all the taps |
| Bail | Retrieve the result of the first tap that handles the calling value |
| Loop | Execute taps until no taps request the loop be restarted |

Visit our [site](https://intuit.github.io/swift-hooks/documentation/swifthooks/) for information about how to use SwiftHooks.

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

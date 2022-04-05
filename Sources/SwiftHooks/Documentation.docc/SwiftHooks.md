# ``SwiftHooks``

![Logo](hooks.png)

A little module for plugins, in swift.

## Overview
SwiftHooks is a swift package for enabling plugins, based on [tapable](https://github.com/webpack/tapable) and [hooks](https://github.com/intuit/hooks/).

A `Hook` represents a "pluggable" point in a software model. They provide a mechanism for "tapping" into such points to get updates, or apply additional functionality to some typed object.

Check out the <doc:User-Guide> for tutorials and walkthroughs!

### Variety of built in hook types
| Type | Behavior |
|------|----------|
| Basic | Executes the taps with no return value |
| Waterfall | "Reduce" the result through all the taps |
| Bail | Retrieve the result of the first tap that handles the calling value |
| Loop | Execute taps until no taps request the loop be restarted |

### Simple To Use

```swift
let someHook = SyncHook<Int>()

someHook.tap(name: "LoggingPlugin") { (value: Int) -> Void in
    print("new value: \(value)")
}

someHook.call(30)
```

### Asynchronous Hooks with Swift 5.5 structured concurrency
```swift
let asyncHook = AsyncSeriesHook<Int>()

asyncHook.tap(name: "AsyncPlugin") { (value: Int} async -> Void in
    let metaData = await getMetaData()
    print("\(metaData) \(value)")
}

Task {
    await asyncHook.call(30)
}
```

### Extensible
Easily create your own hooks by extending the base hooks:
```swift
class NewHook<Parameters, ReturnType>: BaseSyncHook<Parameters, ReturnType> {
    public func call(_ value: Parameters) -> ReturnType {
        // call the taps
        for tap in taps { ... }
        
        return ...
    }
}
```

## Topics

### Synchronous

- ``SyncHook``
- ``SyncBailHook``
- ``SyncWaterfallHook``
- ``SyncLoopHook``

### Asynchronous

- ``AsyncSeriesHook``
- ``AsyncParallelHook``
- ``AsyncSeriesBailHook``
- ``AsyncSeriesWaterfallHook``
- ``AsyncSeriesLoopHook``
- ``AsyncParallelBailHook``

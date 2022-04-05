let hook = SyncHook<Int>()

hook.interceptRegister { (tap: SyncTapInfo) -> SyncTapInfo? in
    // A new Tap can be returned if modifications are needed
    // or nil can be returned to prevent the tap from registering
    print("Register Interceptor Running")
    guard tap.name == "GoodPlugin" else { return nil }
    return tap
}

hook.tap(name: "GoodPlugin") { val in
    print("GoodPlugin Running \(val)")
}
// Register Interceptor Running

hook.tap(name: "BadPlugin") { val in
    print("BadPlugin Running \(val * 2)")
}
// Register Interceptor Running


hook.call(3)
// GoodPlugin Running 3

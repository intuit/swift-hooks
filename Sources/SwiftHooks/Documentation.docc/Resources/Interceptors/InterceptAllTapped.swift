let hook = SyncLoopHook<Int>()

hook.interceptRegister { (tap: SyncTapInfo) -> SyncTapInfo? in
    // A new Tap can be returned if modifications are needed
    // or nil can be returned to prevent the tap from registering
    print("Register Interceptor Running")
    return tap
}

hook.interceptTap { context, tap in
    print("Tap Interceptor Running \(tap.name)")
}

hook.interceptCall { context, val in
    print("Call Interceptor Running \(val)")
}

hook.interceptLoop { context, val in
    print("Loop Interceptor Running \(val)")
}

var runs = 0

hook.tap(name: "SomePlugin") { context, val in
    guard runs > 0 else { return .restart }
    print("Tap Running \(val)")
    return .continue
}
// Register Interceptor Running


hook.call(3)
// Call Interceptor Running 3
// Tap Interceptor Running SomePlugin
// Loop Interceptor Running 3
// Tap Interceptor Running SomePlugin
// Loop Interceptor Running 3
// Tap Running 3

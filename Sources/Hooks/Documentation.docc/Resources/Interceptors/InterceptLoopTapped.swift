let hook = SyncLoopHook<Int>()

hook.interceptLoop { context, val in
    print("Loop Interceptor Running \(val)")
}

var runs = 0

hook.tap(name: "SomePlugin") { context, val in
    guard runs > 0 else { return .restart }
    print("Tap Running \(val)")
    return .continue
}


hook.call(3)
// Loop Interceptor Running 3
// Loop Interceptor Running 3
// Tap Running 3

let hook = SyncHook<Int>()

hook.interceptCall { context, val in
    print("Call Interceptor Running \(val)")
}

hook.tap(name: "SomePlugin") { context, val in
    print("Tap Running \(val)")
}


hook.call(3)
// Call Interceptor Running 3
// Tap Running 3

let hook = SyncHook<Int>()

hook.interceptTap { context, tap in
    print("Tap Interceptor Running \(tap.name)")
}

hook.tap(name: "SomePlugin") { context, val in
    print("Tap Running \(val)")
}


hook.call(3)
// Interceptor Running SomePlugin
// Tap Running 3

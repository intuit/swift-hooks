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

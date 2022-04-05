let hook = SyncHook<Int>()

hook.interceptRegister { (tap: SyncTapInfo) -> SyncTapInfo? in
    // A new Tap can be returned if modifications are needed
    // or nil can be returned to prevent the tap from registering
    print("Register Interceptor Running")
    guard tap.name == "GoodPlugin" else { return nil }
    return tap
}

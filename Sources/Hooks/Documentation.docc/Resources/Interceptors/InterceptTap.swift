let hook = SyncHook<Int>()

hook.interceptTap { context, tap in
    print("Tap Interceptor Running \(tap.name)")
}

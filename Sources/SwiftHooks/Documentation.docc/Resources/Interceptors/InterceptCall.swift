let hook = SyncHook<Int>()

hook.interceptCall { context, val in
    print("Call Interceptor Running \(val)")
}

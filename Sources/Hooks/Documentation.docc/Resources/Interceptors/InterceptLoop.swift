let hook = SyncLoopHook<Int>()

hook.interceptLoop { context, val in
    print("Loop Interceptor Running \(val)")
}

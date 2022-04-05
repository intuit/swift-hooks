struct CarHooks {
    let brake = SyncHook<Void>()
    let accelerate = SyncHook<Int>()
}

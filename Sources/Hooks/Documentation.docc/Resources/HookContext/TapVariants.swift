let hook = SyncHook<Int>()

hook.tap(name: "WithoutContext") { value in
    print(value)
}

hook.tap(name: "WithContext") { context, value in
    print(value)
}

let someHook = SyncHook<Int>()

let id: String? = someHook.tap(name: "Example") { value in
    print(value)
}

/// `id` will be ``nil`` if the tap was rejected by a register interceptor

id.map { someHook.untap($0) }

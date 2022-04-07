let someHook = SyncHook<Int>()
let specificId = UUID().uuidString
let id: String? = someHook.tap(name: "Example", id: specificId) { value in
    print(value)
}

/// `id` will be ``nil`` if the tap was rejected by a register interceptor

id.map { someHook.untap($0) }
// or use the ID directly
someHook.untap(specificId)

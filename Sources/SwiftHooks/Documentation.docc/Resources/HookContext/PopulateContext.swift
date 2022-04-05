let hook = SyncHook<Int>()

hook.tap(name: "WithoutContext") { value in
    print(value)
}

hook.tap(name: "WithContext") { context, value in
    if context["someFlag"] as? Bool == true {
        print(value * 2)
    } else {
        print(value)
    }
}

hook.interceptTap { context, tap in
    print("\(tap.name) is running")
    context["someFlag"] = true
}

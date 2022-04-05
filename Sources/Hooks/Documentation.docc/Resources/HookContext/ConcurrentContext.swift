let hook = AsyncSeriesHook<Int>()

hook.tapAsync(name: "WithConcurrentContext") { context, value in
    if let flag: Bool = await context["someFlag"], flag {
        print(value * 2)
    } else {
        print(value)
    }
}

hook.interceptTap { context, tap in
    print("\(tap.name) is running")
    context["someFlag"] = true
}

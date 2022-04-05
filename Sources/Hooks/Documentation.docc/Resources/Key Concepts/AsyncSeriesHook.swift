let notificationHook = AsyncSeriesHook<String>()

notificationHook.tapAsync(name: "LoggingPlugin") { message in
    // wait 1 second to simulate network time
    try? await Task.sleep(nanoseconds: 1_000_000_000)
}

notificationHook.tapAsync(name: "AnotherLoggingPlugin") { message in
    // wait 1 second to simulate network time
    try? await Task.sleep(nanoseconds: 1_000_000_000)
}


Task {
    await notificationHook.call("Test Message")
    // task resumes after 2 seconds
}

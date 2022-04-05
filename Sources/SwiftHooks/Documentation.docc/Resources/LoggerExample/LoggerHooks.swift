enum ErrorLog {
    case error(_ error: Error)
    case message(_ message: String)
}

struct LoggerHooks {
    let info = SyncHook<String>()
    let warn = SyncHook<String>()
    let error = SyncHook<ErrorLog>()
}

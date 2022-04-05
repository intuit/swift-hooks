protocol LoggerPlugin {
    func apply(logger: Logger)
}

class Logger {
    /// The hooks that plugins can tap into
    let hooks = LoggerHooks()

    /// Create a new ``Logger`` with the given plugins
    /// - Parameter plugins: Plugins to apply to this ``Logger``
    init(_ plugins: [LoggerPlugin]) {
        for plugin in plugins { plugin.apply(logger: self) }
    }

    /// Log an info level message
    /// - Parameter message: The message to log
    func info(_ message: String) {
        hooks.info.call(message)
    }

    /// Log an warning level message
    /// - Parameter message: The message to log
    func warn(_ message: String) {
        hooks.warn.call(message)
    }

    /// Log an error level message
    /// - Parameter message: The message to log
    func error(_ message: String) {
        hooks.error.call(.message(message))
    }

    /// Log an error level message
    /// - Parameter error: The ``Error`` to log
    func error(_ error: Error) {
        hooks.error.call(.error(error))
    }
}

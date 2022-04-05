/// Plugin to send info log messages to a remote logging server
class RemoteLoggingPlugin: LoggerPlugin {
    func apply(logger: Logger) {
        logger.hooks.info.tap(name: "RemoteLoggingPlugin") { sendMessageToServer("[info]: \($0)") }
        logger.hooks.warn.tap(name: "RemoteLoggingPlugin") { sendMessageToServer("[warn]: \($0)") }
        logger.hooks.error.tap(name: "RemoteLoggingPlugin") { errorLog in
            switch errorLog {
            case .error(let error):
                sendMessageToServer("[error]: \(error.localizedDescription)")
            case .message(let message):
                sendMessageToServer("[error]: \(message)")
            }
        }
    }

    func sendMessageToServer(_ message: String) {
        Task {
            // Send logs to logging server
        }
    }
}

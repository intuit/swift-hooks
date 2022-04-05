/// Simple ``LoggerPlugin`` that transforms swift errors before logging
class ErrorLoggingPlugin: LoggerPlugin {
    func apply(logger: Logger) {
        logger.hooks.error.tap(name: "ErrorLoggingPlugin") { errorLog in
            switch errorLog {
            case .error(let error):
                print(error.localizedDescription)
            case .message(let message):
                print(message)
            }
        }
    }
}

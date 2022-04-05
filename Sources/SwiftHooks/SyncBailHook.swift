/// A synchronous hook that calls handlers in order until a ``BailResult/bail(_:)`` is returned
/// and returns the enclosed value
public class SyncBailHook<Parameters, ReturnType>: BaseSyncHook<Parameters, BailResult<ReturnType?>> {
    /// Calls this hook with parameters
    /// - Parameter value: The parameters to send to the hooks
    /// - Returns: The value from a tap or `nil` if no taps return ``BailResult/bail(_:)``
    public func call(_ value: Parameters) -> ReturnType? {
        var context = context(value)
        for tap in taps {
            let result = tap.handler(&context, value)
            switch result {
            case let .bail(handled): return handled
            default: continue
            }
        }
        return nil
    }
}

public extension SyncBailHook where Parameters == Void {
    /// Call this hook with no parameters
    func call() -> ReturnType? { call(()) }
}

/// The result of a `Bail` hook
public enum BailResult<T> {
    /// Indicates that a tap of the hook wants the associated value to be used
    case bail(_ result: T)
    /// Indicates that a tap of the hook is not handling the call
    case skip
}

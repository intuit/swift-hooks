/// An asynchronous hook that executes the taps in order
/// and returns the result of the first tap to return ``BailResult/bail(_:)``
public class AsyncSeriesBailHook<T, U>: BaseAsyncHook<T, BailResult<U?>> {
    /// Call this hook and retrieve the resulting value
    /// - Parameter value: The parameters to send to the taps
    /// - Returns: The value from a tap or `nil` if no taps return ``BailResult/bail(_:)``
    public func call(_ value: T) async -> U? {
        let context = context(value)
        for tap in taps {
            let result = await tap.handler(context, value)
            switch result {
            case let .bail(handled): return handled
            default: continue
            }
        }
        return nil
    }
}

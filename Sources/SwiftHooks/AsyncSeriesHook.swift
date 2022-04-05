/// An asynchronous hook that calls all the handlers in order and waits for completion
public class AsyncSeriesHook<Parameters>: BaseAsyncHook<Parameters, Void> {
    /// Call this hook to to trigger all taps
    /// - Parameter value: The parameters to send to the taps
    public func call(_ value: Parameters) async {
        let context = context(value)
        for tap in taps {
            await tap.handler(context, value)
        }
    }
}

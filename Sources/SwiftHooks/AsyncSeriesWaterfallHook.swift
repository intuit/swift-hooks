/// An asynchronous hook that performs a `reduce` on taps to get one end result
public class AsyncSeriesWaterfallHook<Parameters>: BaseAsyncHook<Parameters, Parameters> {
    /// Call this hook and retrieve the result
    /// - Parameter value: The parameters to send to the taps
    /// - Returns: The reduced result from all the taps
    public func call(_ value: Parameters) async -> Parameters {
        let context = context(value)
        var result = value
        for tap in taps {
            result = await tap.handler(context, result)
        }
        return result
    }
}

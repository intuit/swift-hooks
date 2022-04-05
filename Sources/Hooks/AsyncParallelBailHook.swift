/// An asynchronous hook that executes all taps at the same time and returns the result
/// of the first tap to return ``BailResult/bail(_:)``
public class AsyncParallelBailHook<Parameters, ReturnType>: BaseAsyncHook<Parameters, BailResult<ReturnType?>> {
    /// Call this hook and retrieve the resulting value
    /// - Parameter value: The parameters to send to the taps
    /// - Returns: The value from a tap or `nil` if no taps return ``BailResult/bail(_:)``
    public func call(_ value: Parameters) async -> ReturnType? {
        var result: ReturnType?
        let context = context(value)
        await withTaskGroup(of: BailResult<ReturnType?>.self, body: { group in
            for tap in taps {
                group.addTask { await tap.handler(context, value) }
            }

            for await maybeBailed in group {
                guard case let .bail(handled) = maybeBailed else { continue }
                group.cancelAll()
                result = handled
                break
            }
        })
        return result
    }
}

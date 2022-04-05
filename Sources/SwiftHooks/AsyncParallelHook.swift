/// An asynchronous hook that calls all the handlers at the same time
public class AsyncParallelHook<Parameters>: BaseAsyncHook<Parameters, Void> {
    /// Call this hook to invoke all taps at the same time
    /// - Parameter value: The parameters to send to taps
    public func call(_ value: Parameters) async {
        let context = context(value)
        await withTaskGroup(of: Void.self, body: { group in
            for tap in taps {
                group.addTask {
                    await tap.handler(context, value)
                }
            }
        })
    }
}

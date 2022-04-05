/// A synchronous hook that runs taps in order
public class SyncHook<Parameters>: BaseSyncHook<Parameters, Void> {
    /// Call this hook with parameters
    /// - Parameter value: The parameters to send to the taps
    public func call(_ value: Parameters) {
        var context = context(value)
        for tap in taps {
            tap.handler(&context, value)
        }
    }
}

public extension SyncHook where Parameters == Void {
    /// Call this hook with no parameters
    func call() {
        call(())
    }
}

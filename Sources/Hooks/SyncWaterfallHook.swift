/**
 A synchronous hook that reduces all the handlers into the end result in order of registration
 */
public class SyncWaterfallHook<T>: BaseSyncHook<T, T> {
    /**
     Call this hook and retrieve the resulting value
     - parameters:
        - value: The initial value to process through the handlers
     - returns: The final result of the handler pipeline
     */
    public func call(_ value: T) -> T {
        var context = context(value)
        return taps.reduce(value) { accumulated, currentValue -> T in
            currentValue.handler(&context, accumulated)
        }
    }
}

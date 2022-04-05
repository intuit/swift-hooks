/// An asynchronous hook that runs taps in a loop until all the tapped closure return ``LoopResult/continue``
public class AsyncSeriesLoopHook<Parameters>: BaseAsyncHook<Parameters, LoopResult> {
    var loopInterceptors = LoopInterceptors<Parameters, AsyncTapInfo<Parameters, LoopResult>, HookContext>()
    override public var interceptors: Interceptors<Parameters, AsyncTapInfo<Parameters, LoopResult>, HookContext> {
        get { loopInterceptors }
        // swiftlint:disable:next unused_setter_value
        set {}
    }

    /// Add a loop interceptor to this hook.
    ///
    /// Loop interceptors are run on each iteration of the loop, receiving the arguments passed to the taps
    /// In loop hooks, the `call` interceptors are only run once, hence the need for loop interceptors
    ///
    /// - Parameter handler: Closure to run on each iteration of the loop
    public func interceptLoop(_ handler: @escaping (inout HookContext, Parameters) -> Void) {
        loopInterceptors.loop.append(handler)
    }

    /// Call this hook to trigger all taps
    ///
    /// Taps will be executed in order until all return ``LoopResult/continue``
    /// restarting the loop whenever ``LoopResult/restart`` is encountered
    ///
    /// - Parameter value: The parameters to send to the taps
    public func call(_ value: Parameters) async {
        var context: HookContext = context(value, runTapInterceptors: false)
        var restart = false
        repeat {
            interceptors.invokeTapInterceptors(context: &context, taps: taps)
            loopInterceptors.invokeLoopInterceptors(context: &context, parameters: value)

            let concurrentContext = ConcurrentContext(with: context)

            for tap in taps {
                let result = await tap.handler(concurrentContext, value)
                if case .restart = result {
                    restart = true
                    break
                } else {
                    restart = false
                }
            }
        } while restart
    }
}

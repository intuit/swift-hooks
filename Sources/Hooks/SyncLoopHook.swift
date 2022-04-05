/// The result of a `Loop` type hook
public enum LoopResult {
    /// Continue to the next tap
    case `continue`
    /// Restart the loop from the beginning
    case restart
}

/// Interceptors for hooks that loop, with an additional interceptor that is run on each loop iteration
public class LoopInterceptors<Parameters, TapType, ContextType>: Interceptors<Parameters, TapType, ContextType> {
    var loop: [CallIntercept] = []

    func invokeLoopInterceptors(context: inout ContextType, parameters: Parameters) {
        for interceptor in loop {
            interceptor(&context, parameters)
        }
    }
}

/// A synchronous hook that runs taps in a loop until all the tapped closures return ``LoopResult/continue``
public class SyncLoopHook<Parameters>: BaseSyncHook<Parameters, LoopResult> {
    var loopInterceptors = LoopInterceptors<Parameters, SyncTapInfo<Parameters, LoopResult>, HookContext>()
    override public var interceptors: Interceptors<Parameters, SyncTapInfo<Parameters, LoopResult>, HookContext> {
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

    /// Invoke this hook to trigger all taps
    ///
    /// This hook will call tapped implementations in order until one returns ``LoopResult/restart``
    /// and will then begin from the beginning of the loop until all taps return ``LoopResult/continue``
    ///
    /// - Parameter value: The parameters to send to the taps
    public func call(_ value: Parameters) {
        var context = context(value, runTapInterceptors: false)
        var restart = false
        repeat {
            interceptors.invokeTapInterceptors(context: &context, taps: taps)
            loopInterceptors.invokeLoopInterceptors(context: &context, parameters: value)

            restart = taps.first { tap in
                let result = tap.handler(&context, value)
                guard case .restart = result else { return false }
                return true
            } != nil
        } while restart
    }
}

import Foundation

/// Context object populated by interceptors before
/// being passed to taps
public typealias HookContext = [String: Any]

/// ``HookContext`` wrapped into an actor for access from `async` functions
public actor ConcurrentContext {
    internal init(with existing: HookContext) {
        context = existing
    }

    internal var context: [String: Any] = [:]

    /// Sets a value in the context
    /// - Parameters:
    ///   - key: The key to set in the dictionary
    ///   - value: The value to set for the key
    public func set(_ key: String, value: Any) {
        context[key] = value
    }

    /// Subscript access
    public subscript<T>(key: String) -> T? { context[key] as? T }
}

/// A Tap object that contains a handler closure for when it is invoked
public struct Tap<FunctionType> {
    public var name: String
    public var id: String
    public var handler: FunctionType
}

/// Base for Hook types that includes interceptor definition and
open class BaseHook<Parameters, TapType> {
    /// The currently added ``TapType`` objects for this hook
    var taps: [TapType] = []

    /// The interceptors for this hook
    open var interceptors = Interceptors<Parameters, TapType, HookContext>()

    public init() {}

    /// Add an interceptor to receive the ``Tap`` object when the hook is tapped.
    /// Allows for modification by returning a ``Tap`` object.
    ///
    /// - Parameter handler: Closure to run when hook is called
    public func interceptRegister(_ handler: @escaping (TapType) -> TapType?) {
        interceptors.register.append(handler)
    }

    /// Add an interceptor to receive tap information when a hook is called.
    /// - Parameter handler: Closure to run when hook is called
    public func interceptTap(_ handler: @escaping (inout HookContext, TapType) -> Void) {
        interceptors.tap.append(handler)
    }

    /// Add an interceptor to receive arguments when a hook is called
    /// - Parameter handler: Closure to run when hook is called
    public func interceptCall(_ handler: @escaping (inout HookContext, Parameters) -> Void) {
        interceptors.call.append(handler)
    }

    /// Sets up the ``HookContext`` for use in sending to tap handlers
    /// - Parameters:
    ///   - parameters: The parameters that the tap handler will be called with
    ///   - runTapInterceptors: Whether or not to run ``interceptTap(_:)`` interceptors
    /// - Returns: Populated ``HookContext``
    internal func context(_ parameters: Parameters, runTapInterceptors: Bool = true) -> HookContext {
        var context: HookContext = [:]
        interceptors.invokeCallInterceptors(context: &context, parameters: parameters)
        if runTapInterceptors {
            interceptors.invokeTapInterceptors(context: &context, taps: taps)
        }
        return context
    }

    /// Generates a random ID to use for tapping hooks
    /// - Returns: A random ID String
    open func generateRandomId() -> String { UUID().uuidString }
}

/// The TapInfo used for Sync hooks
public typealias SyncTapInfo<Parameters, ReturnType> = Tap<(inout HookContext, Parameters) -> ReturnType>

/// Base Implementation of a synchronous hook
open class BaseSyncHook<Parameters, ReturnType>: BaseHook<Parameters, SyncTapInfo<Parameters, ReturnType>> {
    /// Add a handler to this hook
    /// - Parameters:
    ///   - name: The name of the tapping object
    ///   - handler: The handler function to attach to this hook
    /// - Returns: An ID to use for untapping, if tap was not rejected by interceptors
    @discardableResult public func tap(name: String, _ handler: @escaping (Parameters) -> ReturnType) -> String? {
        tap(name: name) { handler($1) }
    }

    /// Add a handler to this hook
    /// - Parameters:
    ///   - name: The name of the tapping object
    ///   - id: The ID to use for tapping
    ///   - handler: The handler function to attach to this hook
    /// - Returns: An ID to use for untapping, if tap was not rejected by interceptors
    @discardableResult public func tap(name: String, id: String, _ handler: @escaping (Parameters) -> ReturnType) -> String? {
        tap(name: name, id: id) { handler($1) }
    }

    /// Add a handler to this hook
    ///
    /// This variation receives ``HookContext`` when being called
    /// - Parameters:
    ///   - name: The name of the tapping object
    ///   - handler: The handler function to attach to this hook
    /// - Returns: An ID to use for untapping, if tap was not rejected by interceptors
    @discardableResult public func tap(name: String, _ handler: @escaping (inout HookContext, Parameters) -> ReturnType) -> String? {
        tap(name: name, id: generateRandomId(), handler)
    }

    /// Add a handler to this hook
    ///
    /// This variation receives ``HookContext`` when being called
    /// - Parameters:
    ///   - name: The name of the tapping object
    ///   - id: The ID to use for tapping
    ///   - handler: The handler function to attach to this hook
    /// - Returns: An ID to use for untapping, if tap was not rejected by interceptors
    @discardableResult public func tap(name: String, id: String, _ handler: @escaping (inout HookContext, Parameters) -> ReturnType) -> String? {
        guard
            let tap = interceptors.invokeRegisterInterceptors(Tap(name: name, id: id, handler: handler))
        else {
            return nil
        }
        untap(id)
        taps.append(tap)
        return id
    }

    /// Removes an tap from this hook
    /// - Parameter id: The ID of the tap to remove
    public func untap(_ id: String) {
        taps = taps.filter { $0.id != id }
    }
}

/// The TapInfo used for Async hooks
public typealias AsyncTapInfo<Parameters, ReturnType> = Tap<(ConcurrentContext, Parameters) async -> ReturnType>

/// Base Implementation of an asynchronous hook
open class BaseAsyncHook<Parameters, ReturnType>: BaseHook<Parameters, AsyncTapInfo<Parameters, ReturnType>> {
    /// Add a synchronous handler to this hook
    ///
    /// - Parameters:
    ///   - name: The name of the tapping object
    ///   - handler: The handler function to attach to this hook
    /// - Returns: An ID to use for untapping, if tap was not rejected by interceptors
    @discardableResult public func tap(name: String, _ handler: @escaping (Parameters) -> ReturnType) -> String? {
        tap(name: name) { handler($1) }
    }

    /// Add a synchronous handler to this hook
    ///
    /// - Parameters:
    ///   - name: The name of the tapping object
    ///   - id: The ID to use for tapping
    ///   - handler: The handler function to attach to this hook
    /// - Returns: An ID to use for untapping, if tap was not rejected by interceptors
    @discardableResult public func tap(name: String, id: String, _ handler: @escaping (Parameters) -> ReturnType) -> String? {
        tap(name: name, id: id) { handler($1) }
    }

    /// Add a synchronous handler to this hook
    ///
    /// Although the handler is synchronous, the executing context is async, so this hook
    /// receives ``ConcurrentContext`` instead of ``HookContext``
    ///
    /// - Parameters:
    ///   - name: The name of the tapping object
    ///   - handler: The handler function to attach to this hook
    /// - Returns: An ID to use for untapping, if tap was not rejected by interceptors
    @discardableResult public func tap(name: String, _ handler: @escaping (ConcurrentContext, Parameters) -> ReturnType) -> String? {
        tapAsync(name: name, handler)
    }

    /// Add a synchronous handler to this hook
    ///
    /// Although the handler is synchronous, the executing context is async, so this hook
    /// receives ``ConcurrentContext`` instead of ``HookContext``
    ///
    /// - Parameters:
    ///   - name: The name of the tapping object
    ///   - id: The ID to use for tapping
    ///   - handler: The handler function to attach to this hook
    /// - Returns: An ID to use for untapping, if tap was not rejected by interceptors
    @discardableResult public func tap(name: String, id: String, _ handler: @escaping (ConcurrentContext, Parameters) -> ReturnType) -> String? {
        tapAsync(name: name, id: id, handler)
    }

    /// Add an asynchronous handler to this hook
    ///
    /// - Parameters:
    ///   - name: The name of the tapping object
    ///   - handler: The handler function to attach to this hook
    /// - Returns: An ID to use for untapping, if tap was not rejected by interceptors
    @discardableResult public func tapAsync(name: String, _ handler: @escaping (Parameters) async -> ReturnType) -> String? {
        tapAsync(name: name) { await handler($1) }
    }

    /// Add an asynchronous handler to this hook
    ///
    /// - Parameters:
    ///   - name: The name of the tapping object
    ///   - handler: The handler function to attach to this hook
    ///   - id: The ID to use for tapping
    /// - Returns: An ID to use for untapping, if tap was not rejected by interceptors
    @discardableResult public func tapAsync(name: String, id: String, _ handler: @escaping (Parameters) async -> ReturnType) -> String? {
        tapAsync(name: name, id: id) { await handler($1) }
    }

    /// Add an asynchronous handler to this hook
    ///
    /// This variation receives ``ConcurrentContext`` when being called
    ///
    /// - Parameters:
    ///   - name: The name of the tapping object
    ///   - handler: The handler function to attach to this hook
    /// - Returns: An ID to use for untapping, if tap was not rejected by interceptors
    @discardableResult public func tapAsync(name: String, _ handler: @escaping (ConcurrentContext, Parameters) async -> ReturnType) -> String? {
        tapAsync(name: name, id: generateRandomId(), handler)
    }

    /// Add an asynchronous handler to this hook
    ///
    /// This variation receives ``ConcurrentContext`` when being called
    ///
    /// - Parameters:
    ///   - name: The name of the tapping object
    ///   - id: The ID to use for tapping
    ///   - handler: The handler function to attach to this hook
    /// - Returns: An ID to use for untapping, if tap was not rejected by interceptors
    @discardableResult public func tapAsync(name: String, id: String, _ handler: @escaping (ConcurrentContext, Parameters) async -> ReturnType) -> String? {
        guard
            let tap = interceptors.invokeRegisterInterceptors(Tap(name: name, id: id, handler: handler))
        else {
            return nil
        }
        taps.append(tap)
        return id
    }

    /// Removes an tap from this hook
    /// - Parameter id: The ID of the tap to remove
    public func untap(_ id: String) {
        taps = taps.filter { $0.id != id }
    }

    /// Sets up the ``ConcurrentContext`` for use in sending to tap handlers
    /// - Parameters:
    ///   - parameters: The parameters that the tap handler will be called with
    ///   - runTapInterceptors: Whether or not to run ``interceptTap(_:)`` interceptors
    /// - Returns: Populated ``ConcurrentContext``
    internal func context(_ parameters: Parameters, runTapInterceptors: Bool = true) -> ConcurrentContext {
        let context: HookContext = context(parameters, runTapInterceptors: runTapInterceptors)
        return ConcurrentContext(with: context)
    }
}

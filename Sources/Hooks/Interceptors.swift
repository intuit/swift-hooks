/// Interceptors are used for introspection or modification of hooks and the tapped implementations
open class Interceptors<Parameters, TapType, ContextType> {
    typealias RegisterIntercept = (TapType) -> TapType?
    typealias CallIntercept = (inout ContextType, Parameters) -> Void
    typealias TapIntercept = (inout ContextType, TapType) -> Void

    var call: [CallIntercept] = []
    var tap: [TapIntercept] = []
    var register: [RegisterIntercept] = []

    func invokeRegisterInterceptors(_ info: TapType) -> TapType? {
        register.reduce(info) { acc, interceptor -> TapType? in
            acc.flatMap { interceptor($0) }
        }
    }

    func invokeCallInterceptors(context: inout ContextType, parameters: Parameters) {
        for interceptor in call {
            interceptor(&context, parameters)
        }
    }

    func invokeTapInterceptors(context: inout ContextType, taps: [TapType]) {
        for interceptor in tap {
            for tapInfo in taps {
                interceptor(&context, tapInfo)
            }
        }
    }
}

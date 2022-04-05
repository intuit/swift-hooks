import Hooks

struct Location {}

struct Route {}

class Car {
    class CarHooks {
        public var accelerate = SyncHook<Int>()
        public var brake = SyncHook<Void>()
        public var calculateRoutes = AsyncSeriesWaterfallHook<([Route], Location, Location)>()
    }

    public let hooks = CarHooks()

    public var speed: Int = 0 {
        didSet {
            hooks.accelerate.call(speed)
        }
    }

    public init(plugins: [CarPlugin]) {
        for plugin in plugins { plugin.apply(car: self) }
    }

    public func useNavigationSystem(source: Location, target: Location) async -> [Route] {
        await hooks.calculateRoutes.call(([], source, target)).0
    }
}

protocol CarPlugin {
    func apply(car: Car)
}

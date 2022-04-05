import XCTest
@testable import SwiftHooks
@testable import ExampleLibrary

class WarningLampPlugin: CarPlugin {
    func apply(car: Car) {
        car.hooks.brake.tap(name: "WarningLampPlugin") {
            // turn on brake lights
        }
    }
}

class SpeedLoggingPlugin: CarPlugin {
    func apply(car: Car) {
        car.hooks.accelerate.tap(name: "SpeedLogginPlugin") { newSpeed in
            print("Accelerating to \(newSpeed)")
        }
    }
}

protocol Navigation {
    func calculateRoutes(source: Location, target: Location) async -> [Route]
}

class MapService: Navigation {
    func calculateRoutes(source: Location, target: Location) async -> [Route] {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return [Route()]
    }
}

class CachedRouteService: Navigation {
    var cached: [Route] = [Route()]
    func calculateRoutes(source: Location, target: Location) async -> [Route] {
        return cached
    }
}

class ExampleLibraryTests: XCTestCase {
    func testCar() async {
        let car = Car(plugins: [WarningLampPlugin(), SpeedLoggingPlugin()])

        let cacheService = CachedRouteService()
        let mapService = MapService()

        car.hooks.calculateRoutes.tapAsync(name: "MapService") { parameters in
            let (routes, source, target) = parameters
            let newRoutes = await mapService.calculateRoutes(source: source, target: target)
            return (routes + newRoutes, source, target)
        }

        car.hooks.calculateRoutes.tapAsync(name: "CachedRoutesService") { parameters in
            let (routes, source, target) = parameters
            let newRoutes = await cacheService.calculateRoutes(source: source, target: target)
            return (routes + newRoutes, source, target)
        }

        let routes = await car.useNavigationSystem(source: Location(), target: Location())

        XCTAssertEqual(routes.count, 2)

        car.speed = 88
    }
}

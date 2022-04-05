class CarLoggerPlugin: CarPlugin {
    func apply(car: Car) {
        car.hooks.brake.tap(name: "logging-brake-hook") {
            print("Turning on brake lights")
        }

        car.hooks.accelerate.tap(name: "logging-accelerate-hook") { speed in
            print("Accelerating to \(speed)")
        }
    }
}

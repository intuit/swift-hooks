func main() {
    var car = Car()

    car.hooks.brake.tap(name: "logging-brake-hook") {
        print("Turning on brake lights")
    }

    car.hooks.accelerate.tap(name: "logging-accelerate-hook") { speed in
        print("Accelerating to \(speed)")
    }

    car.speed = 30
    // Accelerating to 30
    car.speed = 22
    // Turning on brake lights
    // Accelerating to 22
}

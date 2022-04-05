class Car {
    let hooks = CarHooks()

    public init(plugins: [CarPlugin]) {
        for plugin in plugins { plugin.apply(car: self) }
    }

    var speed: Int = 0 {
        set {
            if newValue < speed {
                hooks.brake.call()
            }

            speed = newValue
            hooks.accelerate.call(newValue)
        }
    }
}

public protocol CarPlugin {
    func apply(car: Car)
}

class Car {
    let hooks = CarHooks()

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

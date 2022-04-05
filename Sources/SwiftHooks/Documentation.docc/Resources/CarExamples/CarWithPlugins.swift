func main() {
    var car = Car(plugins: [CarLoggerPlugin()])

    car.speed = 30
    // Accelerating to 30
    car.speed = 22
    // Turning on brake lights
    // Accelerating to 22
}

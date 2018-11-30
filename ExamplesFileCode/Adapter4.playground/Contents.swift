import UIKit

protocol Movemment {
    func run()
}

class Car: Movemment {
    func run() {
        print("Car is running")
    }
}

class Truck: Movemment {
    func run() {
        print("Truck is running")
    }
}

class Airplane {
    func flying() {
        print("Airplace is flying")
    }
}
extension Airplane: Movemment {
    func run() {
        flying()
    }
}
let porsche = Car()

let volvo = Truck()

let boing = Airplane()

var transport: [Movemment] = [porsche, volvo, boing]

func movemmentAll(vehicles: [Movemment]) {
    for vehicle in vehicles {
        vehicle.run()
    }
}
movemmentAll(vehicles: transport)

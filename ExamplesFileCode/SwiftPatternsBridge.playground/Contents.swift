import UIKit

protocol Car {
    func drive()
}

class Sedan: Car {
    func drive() {
        print("drive a sedan")
    }
}

class SUV: Car {
    func drive() {
        print("drive a SUV")
    }
}

class RedSedan: Sedan {
    override func drive() {
        print("drive a red sedan")
    }
}

protocol ColoredCar {
    var car: Car { get set }
    func drive()
}

class RedCar: ColoredCar {
    var car: Car
    
    init(car: Car) {
        self.car = car
    }
    
    func drive() {
        car.drive()
        print("It's red.")
    }
}

class BlueCar: ColoredCar {
    var car: Car
    init(car: Car) {
        self.car = car
    }
    func drive() {
        car.drive()
        print("It's blue")
    }
}
let sedan = Sedan()
let suv = SUV()
let redSedan = RedCar(car: sedan)
let blueSuv = BlueCar(car: suv)
blueSuv.drive()
redSedan.drive()

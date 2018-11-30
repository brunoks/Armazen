import UIKit

protocol Car {
    func drive()
    func turnLeft()
}

class Sedan: Car {
    func turnLeft() {
        print("Turn sedan left")
    }
    
    func drive() {
        print("drive a sedan")
    }
}

class SUV: Car {
    func turnLeft() {
        print("Turn SUV left")
    }
    
    func drive() {
        print("drive a SUV")
    }
}

class RedSedan: Sedan {
    override func drive() {
        print("drive a red sedan")
    }
}

class BlueSuv: SUV {
    override func drive() {
        print("drive a blue SUV")
    }
}

class PinkSuv: SUV {
    override func drive() {
        print("drive a pink SUV")
    }
}

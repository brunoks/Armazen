import UIKit

protocol Personagem {
    func movimento()
}

class Ryu: Personagem {
    func movimento() {
        print("Ryu!")
    }
}

class Ken: Personagem {
    func movimento() {
        print("Ken!")
    }
}

protocol Golpe {
    var personagem: Personagem { get set }
    func action()
}

class Hadouken: Golpe {
    var personagem: Personagem
    
    init(personagem: Personagem) {
        self.personagem = personagem
    }
    
    func action() {
        personagem.movimento()
        print("Hadouken")
    }
}

class Tratratratuken: Golpe {
    var personagem: Personagem
    init(personagem: Personagem) {
        self.personagem = personagem
    }
    func action() {
        personagem.movimento()
        print("Tratratratuken")
    }
}

class Shoryuken: Golpe {
    var personagem: Personagem
    init(personagem: Personagem) {
        self.personagem = personagem
    }
    func action() {
        personagem.movimento()
        print("Shoryuken")
    }
}

let ryu = Ryu()

let hadoukenRyu = Hadouken(personagem: ryu)
hadoukenRyu.action()

let tratukenRyu = Tratratratuken(personagem: ryu)
tratukenRyu.action()

let ken = Ken()
let shoryKen = Shoryuken(personagem: ken)
shoryKen.action()

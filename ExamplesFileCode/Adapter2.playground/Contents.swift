import UIKit

// adaptador com objeto
protocol Target {
    func request()
}
class Adapter: Target {
    var adaptee: Adaptee
    init(adaptee: Adaptee) {
        self.adaptee = adaptee
    }
    func request() {
        adaptee.specificRequest()
    }
}
class Adaptee {
    func specificRequest() {
        print("Specific request")
    }
}
// usage
let adaptee = Adaptee()
let tar = Adapter(adaptee: adaptee)
tar.request()

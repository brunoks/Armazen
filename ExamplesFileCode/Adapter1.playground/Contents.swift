import UIKit


//adaptador de classe com herança
protocol Target {
    func request()
}
class Adaptee {
    func specificRequest() {
        print("Specific request")
    }
}
class Adapter: Adaptee, Target {
    func request() {
        specificRequest()
    }
}
// usage
let tar = Adapter()
tar.request()



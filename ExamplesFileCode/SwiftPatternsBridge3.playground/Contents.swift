import UIKit
import PlaygroundSupport

class ViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alerta = Alerta(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let redAlerta = RedAlert(alerta: alerta)
        let blueAlerta = BlueAlert(alerta: alerta)
        self.view.addSubview(blueAlerta.show())
        self.view.addSubview(redAlerta.show())
    }
    
}
class Alerta: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    func setColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AlertInternet: Alerta {
    override func setColor(_ color: UIColor) {
        self.backgroundColor = color
    }
}

protocol ColoredAlert {
    var alerta: Alerta { get set }
    func show() -> UIView
}
class RedAlert: ColoredAlert {
    var alerta: Alerta
    
    init(alerta: Alerta) {
        self.alerta = alerta
    }
    func show() -> UIView {
        alerta.setColor(.red)
        return self.alerta
    }
}
class BlueAlert: ColoredAlert {
    var alerta: Alerta
    
    init(alerta: Alerta) {
        self.alerta = alerta
    }
    func show() -> UIView {
        alerta.setColor(.blue)
        return self.alerta
    }
}

let viewController = ViewController()
PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true

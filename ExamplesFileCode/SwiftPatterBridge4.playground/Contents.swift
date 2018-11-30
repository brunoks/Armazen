import UIKit
import PlaygroundSupport

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = Button(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 500))
        
        let customB = buttonAvancar(button: button)
        self.view.addSubview(customB.show(#selector(self.actionButton), .blue, "Avançar"))
    }
    @objc func actionButton() {
        print("action")
    }
}

class Button: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .darkGray
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
protocol CustomButtom {
    var button: Button { get set }
    func show(_ selector: Selector,_ color:UIColor,_ title:String)-> UIButton
}

class buttonAvancar: CustomButtom {
    var button: Button
    init(button: Button) {
        self.button = button
    }
    func show(_ selector: Selector,_ color:UIColor,_ title:String)-> UIButton {
        self.button.addTarget(self, action: selector, for: .touchUpInside)
        self.button.backgroundColor = color
        self.button.setTitle(title, for: .normal)
        return self.button
    }
}

let viewController = ViewController()
PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true

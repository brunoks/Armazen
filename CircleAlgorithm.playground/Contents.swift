//: Playground - noun: a place where people can play

import UIKit

class CircleView: UIView {
    override func draw(_ rect: CGRect) {
        //let's do some fancy drawing here
        
        let path = UIBezierPath()
        
        
        
        // x^2 + y^2 = r^2
        
        // cos(θ) = x / r  ==> x = r * cos(θ)
        // sin(θ) = y / r  ==> y = r * sin(θ)
        
        let radius: Double = Double(rect.width) / 2 - 20
        
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        
        path.move(to: CGPoint(x: center.x + CGFloat(radius), y: center.y))
        
        for i in stride(from: 0, to: 361.0, by: 1) {
            // radians = degrees * PI / 180
            let radians = i * Double.pi / 180
            
            let x = Double(center.x) + radius * cos(radians)
            let y = Double(center.y) + radius * sin(radians)
            
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        UIColor.red.setStroke()
        path.lineWidth = 5
        path.stroke()
    }
}

let view = CircleView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
view.backgroundColor = .white






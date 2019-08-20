import Foundation
import UIKit

class BoundingBox {
    let textLayer: CATextLayer
    
    init() {
        CATransaction.setDisableActions(true)
        
        textLayer = CATextLayer()
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.isHidden = true
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.fontSize = 16
        textLayer.font = UIFont(name: "Avenir", size: textLayer.fontSize)
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        
    }
    
    func addToLayer(_ parent: CALayer) {
        parent.addSublayer(textLayer)
    }
    
    func show(frame: CGRect, label: String, color: UIColor) {
        
        textLayer.string = label
        textLayer.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        textLayer.isHidden = false
        
        let attributes = [
            NSAttributedString.Key.font: textLayer.font as Any
        ]
        
        let textRect = label.boundingRect(with: CGSize(width: 400, height: 100),
                                          options: .truncatesLastVisibleLine,
                                          attributes: attributes, context: nil)
        
        let textSize = CGSize(width: textRect.width + 24, height: textRect.height)
        let textOrigin = CGPoint(x: frame.origin.x - 2, y: frame.origin.y - textSize.height)
        
        textLayer.frame = CGRect(origin: textOrigin, size: textSize)
    }
    
    func hide() {
        textLayer.isHidden = true
    }
}


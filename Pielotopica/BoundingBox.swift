import Foundation
import UIKit

class BoundingBoxProvider {
    
    // =============================================================== //
    // MARK: - Properties -
    private static let fontSize:CGFloat = 16
    private static let font = UIFont(name: "Avenir", size: fontSize)

    private static let attributes:[NSAttributedString.Key: Any] = [
        .font: BoundingBoxProvider.font as Any,
        .baselineOffset: -7,
        .foregroundColor: UIColor.white,
    ]

    
    private let label = CATextLayer()
    
    // =============================================================== //
    // MARK: - Methods -
    
    func addToLayer(_ parent: CALayer) {
        parent.addSublayer(label)
    }
    
    func show(at origin: CGPoint, with string: String) {
        let string = "■ \(string) ■"
        label.isHidden = false
        
        CATransaction.setDisableActions(_needsDisableActions(for: string))
        
        let attributedString = NSAttributedString(string: string, attributes: BoundingBoxProvider.attributes)
        label.string = attributedString
                
        label.frame = _calcFrame(with: origin, for: string)
    }
    
    func hide() {
        label.isHidden = true
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    init() {
        label.backgroundColor = UIColor.black.withAlphaComponent(0.4).cgColor
        label.borderColor = UIColor.white.cgColor
        label.borderWidth = 2
        label.isHidden = true
        label.contentsScale = UIScreen.main.scale
        label.fontSize = BoundingBoxProvider.fontSize
        label.font = BoundingBoxProvider.font
        label.alignmentMode = CATextLayerAlignmentMode.center
        label.truncationMode = .middle
    }
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    
    private func _needsDisableActions(for string:String) -> Bool {
        if let cLabel = label.string as? String {
            if cLabel != string {
                return true
            }
        }
        
        return false
    }
    
    private func _calcFrame(with origin: CGPoint, for string: String) -> CGRect {
        let size = _calcFrameSize(for: string)
        
        return CGRect(origin: [origin.x - 2, origin.y - size.height], size: size + [30, 8])
    }

    private func _calcFrameSize(for string: String) -> CGSize {
        let textRect = string.boundingRect(
            with: CGSize(width: 400, height: 100),
            options: .truncatesLastVisibleLine,
            attributes: BoundingBoxProvider.attributes,
            context: nil
        )
        
        return textRect.size
        
    }
}


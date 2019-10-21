//
//  TPControllerNode.swift
//  Pielotopica
//
//  Created by yuki on 2019/10/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSpriteKit
import SpriteKit

public class TPControllerNode: SKSpriteNode {
    // ============================================================ //
    // MARK: - Properties -
    
    // MARK: - Singlton -
    static let shared = TPControllerNode()
    
    // MARK: - Nodes -
    private let _backgroundNode = SKSpriteNode(imageNamed: "TP_controller_background")
    
    private let _handleNode = SKSpriteNode(imageNamed: "TP_controller_handle")
    
    // MARK: - Variables -
    
    private let _handleRadius:CGFloat = 25
    private let _level1Radius:CGFloat = 10
    private let _level2Radius:CGFloat = 20
    private let _edgeRadius:CGFloat = 30
    
    private var _touchStartLocation:CGPoint? = nil
    private var _isMoving = false
    
    // ============================================================ //
    // MARK: - Methods -
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        
        guard _isStartingLocationHandle(location) else { return }
        
        self._startMoving(from: location)
    }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        
        _moveLocation(to: location)
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        _endMoving()
    }

    // MARK: - Privates -
    private func _startMoving(from location: CGPoint) {
        _touchStartLocation = location
        _isMoving = true
    }
    private func _moveLocation(to location: CGPoint) {
        guard _isMoving, let touchStartLocation = _touchStartLocation else { return }
        
        var delta = location - touchStartLocation
        
        /// max指定
        delta = delta.restrictByDistance(30)
        if abs(delta) > _level1Radius {  } 
        
        self._handleNode.position = delta
    }
    private func _endMoving() {
        _isMoving = false
        
        let returnAction = SKAction.move(to: .zero, duration: 0.2)
        returnAction.timingMode = .easeInEaseOut
        _handleNode.run(returnAction)
    }
    
    private func _isStartingLocationHandle(_ location:CGPoint) -> Bool {
        return abs(location) <= _handleRadius
    }
    // ============================================================ //
    // MARK: - Constructor -
    
    private func _setup() {
        // init
        self.size = [0, 0]
        self.isUserInteractionEnabled = true
        
        self.addChild(_backgroundNode)
        self.addChild(_handleNode)
    }
    
    
    private init() {
        super.init(texture: nil, color: .clear, size: .zero)
        
        self._setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Never comes here.")
    }
}

private extension CGPoint {
    func restrictByDistance(_ distance: CGFloat) -> CGPoint {
        if abs(self) <= distance {
            return self
        } else {
            return self.normarized * distance
        }
    }
}

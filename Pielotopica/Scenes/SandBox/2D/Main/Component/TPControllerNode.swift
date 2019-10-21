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

private let _handleRadius:CGFloat = 25
private let _level1Radius:CGFloat = 15
private let _level2Radius:CGFloat = 30
private let _edgeRadius:CGFloat = 30
private let _returnActionDur:TimeInterval = 0.1

public class TPControllerNode: SKNode {
    // ============================================================ //
    // MARK: - Properties -
    
    // MARK: - Singlton -
    static let shared = TPControllerNode()
    
    // MARK: - Variables -
    public enum Speed { case halt, sneak, walk, run }
    
    /// スピードです。
    public var speedLevel:Observable<Speed> {
        return _speedLevel.asObservable()
    }
    
    /// 正規化された絶対値 1 or 0 の方向ベクターです。(停止時は 0 )
    public var vector: Observable<CGPoint> {
        return _normarizedVector.asObservable()
    }
    
    // =============================== //
    // MARK: - Privates -
    
    // MARK: - Nodes -
    private let _backgroundNode = SKSpriteNode(imageNamed: "TP_controller_background")
    
    private let _handleNode = SKSpriteNode(color: .clear, size: [50, 50])
    
    private let _handleNodeTexture = SKTexture(imageNamed: "TP_controller_handle")
    private let _handleNodePressedTexture = SKTexture(imageNamed: "TP_controller_handle_pressed")
    
    // MARK: - Variables -
    
    private var _delta = BehaviorRelay(value: CGPoint.zero)
    private var _touchStartLocation:CGPoint? = nil
    private var _isSelected = BehaviorRelay(value: false)
    private let _speedLevel = BehaviorRelay(value: Speed.halt)
    private let _normarizedVector = BehaviorRelay(value: CGPoint.zero)
    
    // MARK: - Constants -
    
    private let bag = DisposeBag()
    
    // ============================================================ //
    // MARK: - Methods -
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        RMTapticEngine.impact.prepare(.light)
        guard let location = touches.first?.location(in: self) else { return }
        
        guard _isStartingLocationHandle(location) else { return }
        
        RMTapticEngine.impact.feedback(.light)
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
        _isSelected.accept(true)
    }
    private func _moveLocation(to location: CGPoint) {
        guard _isSelected.value, let touchStartLocation = _touchStartLocation else { return }
        
        var delta = location - touchStartLocation
        
        /// max指定
        delta = delta.restrictByDistance(30)
        
        _delta.accept(delta)
    
    }
    private func _endMoving() {
        _isSelected.accept(false)
        
        let returnAction = SKAction.move(to: .zero, duration: _returnActionDur)
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
        self.isUserInteractionEnabled = true
        
        /// add
        self.addChild(_backgroundNode)
        self.addChild(_handleNode)
        
        /// rx
        self._isSelected
            .map{[unowned self] in $0 ? self._handleNodePressedTexture : self._handleNodeTexture }
            .bind(to: self._handleNode.rx.texture)
            .disposed(by: bag)
        
        self._delta
            .bind(to: self._handleNode.rx.position)
            .disposed(by: bag)
        
        self._delta
            .map{ Speed.fromV(abs($0))  }
            .bind(to: _speedLevel)
            .disposed(by: bag)
        
        
        self._delta
            .map{ $0.normarized }
            .bind(to: _normarizedVector)
            .disposed(by: bag)
    }
    
    
    private override init() {
        super.init()
        
        self._setup()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("Never.") }
}

private extension TPControllerNode.Speed {
    static func fromV(_ v: CGFloat) -> TPControllerNode.Speed {
        switch v {
        case 0:
            return .halt
            
        case 0..<_level1Radius:
            return .sneak
            
        case _level1Radius..<_level2Radius:
            return .walk
            
        default:
            return .run
            
        }
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

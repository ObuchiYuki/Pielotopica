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
    
    // MARK: - Rx -
    public var isUpSelected: BehaviorRelay<Bool>    { self._upButton.isSelected }
    public var isDownSelected: BehaviorRelay<Bool>  { self._downButton.isSelected }
    public var isRightSelected: BehaviorRelay<Bool> { self._rightButton.isSelected }
    public var isLeftSelected: BehaviorRelay<Bool>  { self._leftButton.isSelected }
    
    // MARK: - Nodes -
    private let _upButton = _TPControllerNodeButton(
        defaultTexture: "TP_controller_up",
        selectedTexture: "TP_controller_up_pressed"
    )
    
    private let _downButton = _TPControllerNodeButton(
        defaultTexture: "TP_controller_down",
        selectedTexture: "TP_controller_down_pressed"
    )
    
    private let _rightButton = _TPControllerNodeButton(
        defaultTexture: "TP_controller_right",
        selectedTexture: "TP_controller_right_pressed"
    )
    
    private let _leftButton = _TPControllerNodeButton(
        defaultTexture: "TP_controller_left",
        selectedTexture: "TP_controller_left_pressed"
    )
    // ============================================================ //
    // MARK: - Constructor -
    
    private func _setup() {
        // init
        self.size = [0, 0]
        
        // add target
        
        _upButton.position = [0, 25]
        _downButton.position = [0, -25]
        _rightButton.position = [50, 0]
        _leftButton.position = [-50, 0]
        
        self.addChild(_upButton)
        self.addChild(_downButton)
        self.addChild(_rightButton)
        self.addChild(_leftButton)
    }
    
    
    private init() {
        super.init(texture: nil, color: .clear, size: .zero)
        
        self._setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Never comes here.")
    }
}

// ============================================================ //
// MARK: - _TPControllerNodeButton -
private class _TPControllerNodeButton: SKSpriteNode {
        
    // ============================================================ //
    // MARK: - Proeprties -
    
    fileprivate var isSelected = BehaviorRelay(value: false)
    
    // MARK: - Nodes -
    private let defaultTexture:SKTexture
    private let selectedTexture: SKTexture
    
    private var bag = DisposeBag()
    
    // ============================================================ //
    // MARK: - Constructor -
    
    init(defaultTexture: String, selectedTexture: String) {
        self.defaultTexture = .init(imageNamed: defaultTexture)
        self.selectedTexture = .init(imageNamed: selectedTexture)
        
        super.init(texture: nil, color: .clear, size: [43, 43])
        
        self.isUserInteractionEnabled = true
        
        // rx binding.
        self.isSelected
            .map { $0 ? self.selectedTexture : self.defaultTexture }
            .bind(to: self.rx.texture)
            .disposed(by: bag)
        
        self.rx.touchesBegan
            .map{_, _ in true}
            .bind(to: isSelected)
            .disposed(by: bag)
        
        self.rx.touchesEnded
            .map{_, _ in false}
            .bind(to: isSelected)
            .disposed(by: bag)
        
        self.rx.touchesCancelled
            .map{_, _ in false}
            .bind(to: isSelected)
            .disposed(by: bag)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}



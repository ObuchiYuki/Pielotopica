//
//  TPControllerNode.swift
//  Pielotopica
//
//  Created by yuki on 2019/10/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPControllerNode: SKSpriteNode {
    // ============================================================ //
    // MARK: - Properties -
    
    // MARK: - Singlton -
    static let shared = TPControllerNode()
    
    // MARK: - Nodes -
    private let _topButton = GKButtonNode(
        size: [43, 43],
        defaultTexture: .init(imageNamed: "TP_controller_top"),
        selectedTexture: .init(imageNamed: "TP_controller_top_pressed")
    )
    
    private let _bottomButton = GKButtonNode(
        size: [43, 43],
        defaultTexture: .init(imageNamed: "TP_controller_top"),
        selectedTexture: .init(imageNamed: "TP_controller_top_pressed")
    )
    
    private let _rightButton = GKButtonNode(
        size: [43, 43],
        defaultTexture: .init(imageNamed: "TP_controller_top"),
        selectedTexture: .init(imageNamed: "TP_controller_top_pressed")
    )
    
    private let _leftButton = GKButtonNode(
        size: [43, 43],
        defaultTexture: .init(imageNamed: "TP_controller_top"),
        selectedTexture: .init(imageNamed: "TP_controller_top_pressed")
    )
    
    // ============================================================ //
    // MARK: - Methods -
    
    // MARK: - Handler -
    
    @objc private func _handleTopButton(_ sender: Any) {
        
    }
    @objc private func _handleBottomButton(_ sender: Any) {
        
    }
    @objc private func _handleRightButton(_ sender: Any) {
        
    }
    @objc private func _handleLeftButton(_ sender: Any) {
        
    }
    // ============================================================ //
    // MARK: - Constructor -
    
    private func _setup() {
        // init
        self.size = [135, 95]
        
        // add target
        self._topButton.addTarget(self, action: #selector(_handleTopButton), for: .touchUpInside)
        self._bottomButton.addTarget(self, action: #selector(_handleBottomButton), for: .touchUpInside)
        self._rightButton.addTarget(self, action: #selector(_handleRightButton), for: .touchUpInside)
        self._leftButton.addTarget(self, action: #selector(_handleLeftButton), for: .touchUpInside)
        
    }
    
    
    init() {
        super.init(texture: nil, color: .clear, size: .zero)
        
        self._setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self._setup()
    }
}


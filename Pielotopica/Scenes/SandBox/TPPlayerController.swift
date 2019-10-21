//
//  TPPlayerController.swift
//  Pielotopica
//
//  Created by yuki on 2019/10/15.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSpriteKit
import SceneKit

// ====================================================== //
// MARK: - TPPlayerController -
public class TPPlayerController {
    // ====================================================== //
    // MARK: - Properties -
    
    public var playerPosition = BehaviorRelay(value: SCNVector3.zero)
    
    
    public var controllerState = _ControllerState()
    
    public class _ControllerState {
        /// (min, max) = (-1, 1)
        public var horizontalVector = BehaviorRelay(value: CGPoint.zero)
        
        /// (min, max) = (-1, 1)
        public var varticalVector = BehaviorRelay(value: CGPoint.zero)
        
    }
    
    // ====================================================== //
    // MARK: - Methods -
}

//
//  TSPlayer.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/05.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import RxCocoa

public class TSPlayer {
    // ================================================================= //
    // MARK: - Property -
    
    public let name:String
    
    public var inventory = TSInventry(amount: 32)
    public var itemBarInventory = TSItemBarInventory()
    public var position = BehaviorRelay(value: SCNVector3.zero)
    
    // ================================================================= //
    // MARK: - COnstructor -
    init(named name:String) {
        self.name = name
    }
}

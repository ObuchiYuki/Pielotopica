//
//  TSPlayer.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/05.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import RxCocoa

/// ゲームのプレイヤーです。
/// しばらくは1人のみと思っていいです（マルチプレーは想定外）
public class TSPlayer {
    // ================================================================= //
    // MARK: - Property -
    
    public let name:String
    
    public var inventory = TSInventory(amount: 32)
    public var itemBarInventory = TSItemBarInventory()
    public var position = BehaviorRelay(value: SCNVector3.zero)
    
    // ================================================================= //
    // MARK: - COnstructor -
    init(named name:String) {
        self.name = name
    }
    
    /// 仮
    public static let him = TSPlayer(named: "Kai.e3")
}

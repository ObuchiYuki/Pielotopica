//
//  TSBlockItem.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/05.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

private let kBlockItemMargin:UInt16 = 10000

/// ブロックとして置けるアイテムを表します。
public class TSBlockItem: TSItem {
    /// 管理元のブロックです。
    public let block:TSBlock!
    
    public init(name:String, textureNamed textureName:String ,block:TSBlock) {
        self.block = block
        
        super.init(name: name, index: block.index + kBlockItemMargin, textureNamed: textureName)
        
    }
    
    public override init(name: String, index: UInt16, textureNamed textureName: String) {
        self.block = nil
        print("Never come here")
        
        super.init(name: name, index: index, textureNamed: textureName)
        
    }
}

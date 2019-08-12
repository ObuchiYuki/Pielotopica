//
//  TSBlockManager.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/05.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

/// ブロックの管理を行います。
public class TSBlockManager {
    /// シングルトン
    public static let `default` = TSBlockManager()
    
    /// 登録済みブロック一覧
    private var blocks = [TSBlock]()
    
    /// ブロックを登録します。
    public func registerBlock(_ block:TSBlock) {
        self.blocks.append(block)
    }
    public func registerBlocks(_ tblocks:[TSBlock]) {
        tblocks.forEach{
            blocks.append($0)
        }
    }
    
    internal func block(for identifier:String) -> TSBlock? {
        return self.blocks.first(where: {$0.identifier == identifier})
    }
    internal func block(for index:UInt16) -> TSBlock? {
        return self.blocks.first(where: {$0.index == index})
    }
}

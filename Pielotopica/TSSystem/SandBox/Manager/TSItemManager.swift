//
//  TSItemManager.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/05.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import XCGLogger

/**
 アイテムの管理を提供します。
 */
public class TSItemManager {
    // ================================================================== //
    // MARK: - Singleton -
    public static let `default` = TSItemManager()
    
    // ================================================================== //
    // MARK: - Private Properties -
    private var items = [TSItem]()
    
    // ================================================================== //
    // MARK: - Public Methods -
    public func registerItem(_ item:TSItem) {
        self.items.append(item)
    }
    
    public func item(for index:Int) -> TSItem{
        guard let item = items.first(where: {$0.index == index}) else {
            fatalError("Item indexed \(index) has not been registered yet. Please register it first.")
        }
        
        return item
    }
}

//
//  TSItem.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/05.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

/**
 SandBoxにおけるアイテムを表すクラスです。
 各アイテムに対してインスタンスは1つのみとします。
 複数作成した場合の動作は。。。多分落ちる
 
 複数個のアイテムは、TSItemStackを用いて表してください。
 */
public class TSItem {
    // ===================================================================== //
    // MARK: - Public Properties -
    
    /// アイテム名です。
    public let name:String
    
    /// ユニークなIndexです。（アイテム番号として使用します。）
    public let index:UInt16
    
    /// テクスチャです。
    public var itemImage:UIImage? { UIImage(named: self._textureName) }
    
    // ===================================================================== //
    // MARK: - Methods -
    
    open func materialsForCraft() -> TSCraftMaterialValue? {nil}
    
    // ===================================================================== //
    // MARK: - Private Properties -
    
    /// テクスチャ名です。
    private let _textureName:String
    
    // ===================================================================== //
    // MARK: - Constructor  -
    
    public init(name:String, index:UInt16, textureNamed textureName:String) {
        assert(TSItem._registerdItems.allSatisfy{$0.index != index}, "TSItem indexed \(index) already exists.")
        
        self.name = name
        self.index = index
        self._textureName = textureName
        
        TSItem._registerdItems.append(self)
    }
}

extension TSItem {
    private static var _registerdItems = [TSItem]()
    
    static func item(for index:UInt16) -> TSItem {
        guard let item = _registerdItems.first(where: {$0.index == index}) else {
            fatalError("Error in finding TSItem indexed \(index)")
        }
        
        return item
    }
}


extension TSItem: CustomStringConvertible {
    public var description: String {
        return "TSItem(named: \(self.name))"
    }
}


// ===================================================================== //
// MARK: - Extension for  Equatable -
extension TSItem: Equatable {
    public static func == (left:TSItem, right:TSItem) -> Bool {
        return left.index == right.index
    }
}

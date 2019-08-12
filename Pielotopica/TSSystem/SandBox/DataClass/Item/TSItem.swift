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
 複数作成した場合の動作は未定義です。
 
 複数個のアイテムは、TSItemStackを用いて表してください。
 */
public class TSItem {
    // ===================================================================== //
    // MARK: - Public Properties -
    
    /// アイテム名です。（今のことろ日本語）
    public let name:String
    
    /// ユニークなIndexです。（アイテム番号として使用します。）
    public let index:UInt16
    
    public lazy var itemImage:UIImage? = {
        return UIImage(named: self._textureName)
    }()
    
    // ===================================================================== //
    // MARK: - Private Properties -
    
    /// テクスチャ名です。
    private let _textureName:String
    
    // ===================================================================== //
    // MARK: - Constructor  -
    
    public init(name:String, index:UInt16, textureNamed textureName:String) {
        self.name = name
        self.index = index
        self._textureName = textureName
    }
}

extension TSItem: CustomStringConvertible {
    public var description: String {
        return "[TSItem name: \(self.name)]" 
    }
}
// ===================================================================== //
// MARK: - Extension for  Equatable -
extension TSItem: Equatable {
    public static func == (left:TSItem, right:TSItem) -> Bool {
        return left.index == right.index
    }
}

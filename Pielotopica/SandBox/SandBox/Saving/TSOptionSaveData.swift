//
//  TSOptionSaveData.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/14.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public struct TSOptionSaveData: Codable {
    public static var shared = TSOptionSaveData() {
        didSet { shared.isEdited = true }
    }
    
    /// 編集済みか
    public var isEdited: Bool = false
    
    /// 設定ファイルのバージョン番号。
    public var version: String = "op.1.0"
    
    /// プレイヤーから見える = チャンクの描画距離半径
    public var renderDistance: Int = 6
    
    /// 音楽の音量
    public var musicVolume: Float = 0.5
    
    /// 効果音の音量
    public var seVolume: Float = 0.5
    
    /// 影を表示するかどうか
    public var shadow: Bool = true
    
    init() {
        TSFileSaveManager.shared.register(self)
    }
}

extension TSOptionSaveData: TSTickBasedSavable {
    public var tickPerSave: UInt {
        return UInt(10.0 / TSTick.unit)
    }
    
    public func save() {
        RMStorage.shared.store(self, for: ._optionSaveDataKey)
    }
}


extension RMStorage.Key {
    fileprivate static var _optionSaveDataKey: RMStorage.Key<TSOptionSaveData> {
        return RMStorage.Key(rawValue: "options.box")
    }
}

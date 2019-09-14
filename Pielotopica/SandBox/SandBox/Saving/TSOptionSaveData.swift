//
//  TSOptionSaveData.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/14.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public struct TSOptionSaveData {
    static let shared = TSOptionSaveData() {
        didSet {
            
        }
    }
    
    /// 編集済みか
    var isEdited: Bool = false
    
    /// 設定ファイルのバージョン番号。
    var version: String
    
    /// プレイヤーから見えるチャンクの描画距離半径
    var renderDistance: Int = 10
    
    /// 音楽の音量
    var musicVolume: Float = 0.5
    
    /// 効果音の音量
    var seVolume: Float = 0.5
    
    /// 影を表示するかどうか
    var shadow: Bool = true
}

extension TSOptionSaveData: TSTickBasedSavable {
    public var tickPerSave: UInt {
        return UInt(10.0 / TSTick.unit)
    }
    
    public func save() {
        RMStorage.shared.store(self, for: ._levelSaveDataKey(for: self.levelName))
    }
}


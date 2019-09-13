//
//  TSLevelSaveData.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

private class TSLevelSaveData: Codable {
    
    // MARK: - Singleton -
    public static let shared = TSLevelSaveData()
    
    // MARK: - Constructor -
    
    init(levelName: String, generatorName: GeneratorName, randomSeed: String) {
        self.levelName = levelName
        self.generatorName = generatorName
        self.randomSeed = randomSeed
    }
    
    
    // MARK: - Properties -
    
    /// version of save data.
    var saveVersion: Int16 = 0
    
    /// whether the level is properly initialized.
    var initialized:Bool = 0
    
    ///  The name of the level. defalut is "default".
    var levelName: String
    
    /// The name of the generator.
    var generatorName:GeneratorName
    enum GeneratorName: UInt8, Codable {case `default` = 0, flat = 1, debug = 2}
    
    /// The random level seed used to generate consistent terrain.
    var randomSeed: String
    
    ///  The game rules.
    var gameRules: GameRules
    
    struct GameRules: Codable {
        /// whether the debug mode on.
        var debug: Bool
            
    }
    
    /// プレイヤーデータ
    var player:Player
    
    struct Player: Codable {
        
        /// 現在のプレイヤー位置
        var positionX: Int16
        var positionY: Int16
        var positionZ: Int16
        
        /// プレイヤーが存在するディメンション。今のところ 0 (= 地上のみ)
        var dimension: UInt8
        
        /// 現在のスコア
        var score: Int32
        
        /// プレイヤーの選択したホットバーのスロット。
        var selectedItemSlot: UInt8
        
        /// 現在のアイテムバーのアイテム
        var selectedItems: Item
        
        struct Item: Codable {
            ///  アイテムのスタック数。
            var count: UInt32
            
            /// アイテムのあるスロット番号。
            var slot: UInt32
            
            /// アイテムの `id`
            var id: UInt16
            
            /// アイテムのデータ値。道具の場合は「ダメージ値」になる。
            var data:UInt16
        }
    }
    
    /// Information about the Topica version the world was saved in.
    var version: Version
    
    struct Version: Codable {
        /// An identifier for the version.
        var id: Int32
        /// The version name as a string, e.g. "tp.1.0.1"
        var name: String
        /// Whether the version is debug
        var debug: Bool
    }
}

extension RMStorage.Key {
    fileprivate static var _TSLevelSaveDataKey:RMStorage.Key<_TSLevelSaveData> { return RMStorage.Key(rawValue: "level.box") }
}

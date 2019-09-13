//
//  TSLevelSaveData.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class TSLevelSaveData {
    
    
    
    /// whether the level is properly initialized.
    public var initialized:Bool = false
    
    ///  The name of the level. defalut is "default".
    public var levelName: String
    
    /// The name of the generator.
    public var generatorName:GeneratorName
    public enum GeneratorName: UInt8, Codable {case `default` = 0, flat = 1, debug = 2}
    
    /// The random level seed used to generate consistent terrain.
    public var randomSeed: String
    
    ///  The game rules.
    public var gameRules: GameRules
    
    public struct GameRules: Codable {
        /// whether the debug mode on.
        public var debug: Bool = false
            
    }
    
    /// プレイヤーデータ
    public var player:Player
    
    public struct Player: Codable {
        
        /// 現在のプレイヤー位置
        public var positionX: Int16 = 0
        public var positionY: Int16 = 0
        public var positionZ: Int16 = 0
        
        /// プレイヤーが存在するディメンション。今のところ 0 (= 地上) のみ
        public var dimension: UInt8 = 0
        
        /// 現在のスコア
        public var score: Int32 = 0
        
        /// プレイヤーの選択したホットバーのスロット。
        public var selectedItemSlot: UInt8 = 0
        
        /// 現在のアイテムバーのアイテム
        public var selectedItems: [Item] = []
        
        public struct Item: Codable {
            ///  アイテムのスタック数。
            public var count: UInt32 = 0
            
            /// アイテムのあるスロット番号。
            public var slot: UInt32 = 0
            
            /// アイテムの `id`
            public var id: UInt16 = 0
            
            /// アイテムのデータ値。道具の場合は「ダメージ値」になる。
            public var data:UInt16 = 0
        }
    }
    
    /// Information about the Topica version the world was saved in.
    public var version: Version = .current
    
    public struct Version: Codable {
        /// An identifier for the version.
        public var id: Int32
        /// The version name as a string, e.g. "tp.1.0.1"
        public var name: String
        /// Whether the version is debug
        public var debug: Bool
    }
    
    init(levelName: String, generatorName: GeneratorName, randomSeed: String) {
        self.levelName = levelName
        self.generatorName = generatorName
        self.randomSeed = randomSeed
    }
}

extension RMStorage.Key {
    fileprivate static var _TSLevelSaveDataKey:RMStorage.Key<_TSLevelSaveData> { return RMStorage.Key(rawValue: "level.box") }
}

private class TSLevelSaveData: Codable {
    
    public static let shared = TSLevelSaveData()
    
    /// version of save data.
    var saveVersion: Int16
    
    /// whether the level is properly initialized.
    var initialized:Bool
    
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
    
    
    
    init(data: TSLevelSaveData) {
        //...
    }
}

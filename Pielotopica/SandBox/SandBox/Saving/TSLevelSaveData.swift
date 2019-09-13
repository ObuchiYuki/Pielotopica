//
//  TSLevelSaveData.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class TSLevelSaveData: Codable {
    
    // MARK: - Singleton -
    public static let shared = TSLevelSaveData()
    
    // MARK: - Constructor -
    
    public init(levelName: String, generatorName: GeneratorName, randomSeed: String) {
        self.levelName = levelName
        self.generatorName = generatorName
        self.randomSeed = randomSeed
    }
    
    
    // MARK: - Properties -
    
    /// version of save data.
    public var saveVersion: Int16 = 0
    
    /// whether the level is properly initialized.
    public var initialized:Bool = 0
    
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
        public var debug: Bool
            
    }
    
    /// プレイヤーデータ
    public var player:Player
    
    public struct Player: Codable {
        
        /// 現在のプレイヤー位置
        public var positionX: Int16
        public var positionY: Int16
        public var positionZ: Int16
        
        /// プレイヤーが存在するディメンション。今のところ 0 (= 地上のみ)
        public var dimension: UInt8
        
        /// 現在のスコア
        public var score: Int32
        
        /// プレイヤーの選択したホットバーのスロット。
        public var selectedItemSlot: UInt8
        
        /// 現在のアイテムバーのアイテム
        public var selectedItems: [Item]
        
        public struct Item: Codable {
            ///  アイテムのスタック数。
            public var count: UInt32
            
            /// アイテムのあるスロット番号。
            public var slot: UInt32
            
            /// アイテムの `id`
            public var id: UInt16
            
            /// アイテムのデータ値。道具の場合は「ダメージ値」になる。
            public var data:UInt16
        }
    }
    
    /// Information about the Topica version the world was saved in.
    public var version: Version
    
    public struct Version: Codable {
        /// An identifier for the version.
        public var id: Int32
        /// The version name as a string, e.g. "tp.1.0.1"
        public var name: String
        /// Whether the version is debug
        public var debug: Bool
    }
}

extension RMStorage.Key {
    fileprivate static var _TSLevelSaveDataKey:RMStorage.Key<_TSLevelSaveData> { return RMStorage.Key(rawValue: "level.box") }
}

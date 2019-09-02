//
//  TPMaterialValueMap.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/26.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation


class TPMaterialValueMap {
    static func getValue(for classIndex:Int) -> TSMaterialValue {
        assert(0 <= classIndex && classIndex < 80)
        
        return allValues[classIndex]
    }
    
    static var needsShowMap:[Bool] = {TPMaterialValueMap.allValues.map{$0.needsShow}}()
        
    static let allValues = [
        // 0 人
        TSMaterialValue(0, false),
        // 1 自転車
        TSMaterialValue(1, iron: 10, wood: 0, circit: 0, true),
        // 2 車
        TSMaterialValue(2, iron: 15, wood: 0, circit: 1, true),
        // 3 バイク
        TSMaterialValue(3, iron: 10, wood: 0, circit: 1, true),
        // 4 飛行機
        TSMaterialValue(4, iron: 50, wood: 0, circit: 5, true),
        // 5 バス
        TSMaterialValue(5, iron: 15, wood: 0, circit: 1, true),
        // 6 電車
        TSMaterialValue(6, iron: 20, wood: 0, circit: 1, true),
        // 7 トラック
        TSMaterialValue(7, iron: 20, wood: 0, circit: 1, true),
        // 8 ボート
        TSMaterialValue(8, iron: 15, wood: 5, circit: 1, true),
        // 9 信号機
        TSMaterialValue(9, iron: 10, wood: 0, circit: 1, true),
        // 10 消火栓
        TSMaterialValue(10, false),
        // 11 停止標識
        TSMaterialValue(11, false),
        // 12 パーキングメーター
        TSMaterialValue(12, false),
        // 13 ベンチ
        TSMaterialValue(13, iron:  0, wood: 10, circit: 0, true),
        // 14 鳥
        TSMaterialValue(14, heart: 5, true),
        // 15 猫
        TSMaterialValue(15, heart: 10, true),
        // 16 犬
        TSMaterialValue(16, heart: 15, true),
        // 17 馬
        TSMaterialValue(17, heart: 10, true),
        // 18 羊
        TSMaterialValue(18, heart: 30, true),
        // 19 牛
        TSMaterialValue(19, heart: 30, true),
        // 20 ゾウ
        TSMaterialValue(20, heart: 50, true),
        // 21 クマ
        TSMaterialValue(21, heart: 50, true),
        // 22 ゼブラ
        TSMaterialValue(22, heart: 50, true),
        // 23 キリン
        TSMaterialValue(23, heart: 50, true),
        // 24 バックパック
        TSMaterialValue(24, iron:  0, wood: 5, circit: 0, true),
        // 25 傘
        TSMaterialValue(25, iron:  5, wood: 5, circit: 0, true),
        // 26 ハンドバッグ
        TSMaterialValue(26, iron:  0, wood: 5, circit: 0, true),
        // 27 ネクタイ
        TSMaterialValue(27, iron:  0, wood: 5, circit: 0, true),
        // 28 スーツケース
        TSMaterialValue(28, iron:  5, wood: 5, circit: 0, true),
        // 29 フリスビー
        TSMaterialValue(29, iron:  0, wood: 5, circit: 0, true),
        // 30 スキー
        TSMaterialValue(30, iron:  5, wood: 5, circit: 0, true),
        // 31 スノーボード
        TSMaterialValue(31, iron:  5, wood: 5, circit: 0, true),
        // 32 スポーツボール
        TSMaterialValue(32, iron:  0, wood: 5, circit: 0, true),
        // 33 タコ
        TSMaterialValue(33, iron:  0, wood: 5, circit: 0, true),
        // 34 バット
        TSMaterialValue(34, iron:  0, wood: 5, circit: 0, true),
        // 35 グローブ
        TSMaterialValue(35, iron:  0, wood: 5, circit: 0, true),
        // 36 スケートボード
        TSMaterialValue(36, iron:  5, wood: 5, circit: 0, true),
        // 37 サーフボード
        TSMaterialValue(37, iron:  5, wood: 5, circit: 0, true),
        // 38 テニスラケット
        TSMaterialValue(38, iron:  5, wood: 5, circit: 0, true),
        // 39 ボトル
        TSMaterialValue(39, iron:  5, wood: 0, circit: 0, true),
        // 40 ワイングラス
        TSMaterialValue(40, iron:  5, wood: 0, circit: 0, true),
        // 41 カップ
        TSMaterialValue(41, iron:  3, wood: 2, circit: 0, true),
        // 42 フォーク
        TSMaterialValue(42, iron:  3, wood: 0, circit: 0, true),
        // 43 ナイフ
        TSMaterialValue(43, iron:  3, wood: 0, circit: 0, true),
        // 44 スプーン
        TSMaterialValue(44, iron:  3, wood: 0, circit: 0, true),
        // 45 ボール
        TSMaterialValue(45, iron:  3, wood: 0, circit: 0, true),
        // 46 バナナ
        TSMaterialValue(46, fuel: 5, true),
        // 47 アップル
        TSMaterialValue(47, fuel: 5, true),
        // 48 サンドイッチ
        TSMaterialValue(48, fuel: 10, true),
        // 49 オレンジ
        TSMaterialValue(49, fuel: 5, true),
        // 50 ブロッコリー
        TSMaterialValue(50, fuel: 5, true),
        // 51 にんじん
        TSMaterialValue(51, fuel: 5, true),
        // 52 ホットドッグ
        TSMaterialValue(52, fuel: 10, true),
        // 53 ピザ
        TSMaterialValue(53, fuel: 20, true),
        // 54 ドーナツ
        TSMaterialValue(54, fuel: 20, true),
        // 55 ケーキ
        TSMaterialValue(55, fuel: 30, true),
        // 56 チェア
        TSMaterialValue(56, iron:  0, wood: 5, circit: 0, true),
        // 57 ソファー
        TSMaterialValue(57, iron:  3, wood: 5, circit: 0, true),
        // 58 鉢植え
        TSMaterialValue(58, iron:  2, wood: 2, circit: 0, true),
        // 59 ベッド
        TSMaterialValue(59, iron:  2, wood: 2, circit: 0, true),
        // 60 ダイニングテーブル
        TSMaterialValue(60, iron:  0, wood: 5, circit: 0, true),
        // 61 トイレ
        TSMaterialValue(61, iron:  2, wood: 2, circit: 0, true),
        // 62 テレビモニター
        TSMaterialValue(62, iron:  5, wood: 0, circit: 1, true),
        // 63 ノートパソコン
        TSMaterialValue(63, iron:  5, wood: 0, circit: 2, true),
        // 64 マウス
        TSMaterialValue(64, iron:  5, wood: 0, circit: 1, true),
        // 65 リモコン
        TSMaterialValue(65, iron:  5, wood: 0, circit: 1, true),
        // 66 キーボード
        TSMaterialValue(66, iron:  5, wood: 0, circit: 0, true),
        // 67 携帯電話
        TSMaterialValue(67, iron:  5, wood: 0, circit: 1, true),
        // 68 電子レンジ
        TSMaterialValue(68, iron:  5, wood: 0, circit: 1, true),
        // 69 オーブン
        TSMaterialValue(69, iron:  5, wood: 0, circit: 0, true),
        // 70 トースター
        TSMaterialValue(70, iron:  5, wood: 0, circit: 0, true),
        // 71 流し台
        TSMaterialValue(71, iron:  0, wood: 5, circit: 0, true),
        // 72 冷蔵庫
        TSMaterialValue(72, iron:  5, wood: 0, circit: 0, true),
        // 73 本
        TSMaterialValue(73, iron:  0, wood: 5, circit: 0, true),
        // 74 時計
        TSMaterialValue(74, iron:  5, wood: 0, circit: 0, true),
        // 75 花瓶
        TSMaterialValue(75, iron:  5, wood: 0, circit: 0, true),
        // 76 はさみ
        TSMaterialValue(76, iron:  5, wood: 0, circit: 0, true),
        // 77 テディベア
        TSMaterialValue(77, iron:  50, wood: 50, circit: 5, true),
        // 78 ヘアドライヤー
        TSMaterialValue(78, iron:  5, wood: 0, circit: 0, true),
        // 79 歯ブラシ
        TSMaterialValue(79, iron:  0, wood: 5, circit: 0, true),
    ]
}

struct TSMaterialValue {
    let classIndex:Int
    
    let iron:Int
    let wood:Int
    let circit:Int
    let heart:Int
    let fuel:Int
    
    let needsShow:Bool
    
    fileprivate init(_ classIndex:Int, iron:Int=0, wood:Int=0, circit:Int=0, heart:Int=0,fuel:Int=0, _ needsShow:Bool) {
        self.classIndex = classIndex
        
        self.iron = iron
        self.wood = wood
        self.circit = circit
        self.heart = heart
        self.fuel = fuel
        
        self.needsShow = needsShow
    }
}

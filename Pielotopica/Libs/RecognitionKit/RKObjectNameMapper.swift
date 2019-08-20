//
//  RKObjectNameMapper.swift
//  TPCaptureScene
//
//  Created by yuki on 2019/07/11.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

// =============================================================== //
// MARK: - YOLOObjectNameMapper -

/**
 YOLOの認識によって得られたClassIndexを表示名に変更します。
 */


internal class RKObjectNameMapper {
    
    internal func name(at classIndex:Int, for region:RKObjectDetector.Region) -> String {
        assert(0 <= classIndex && classIndex < 80 , "ClassIndex must be between 0 and 80.")
        
        switch region {
        case .japanese:
            return yoloObjectLabel_ja[classIndex]
        case .english:
            return yoloObjectLabel_en[classIndex]
        }
    }
}

// The labels for the 80 classes.
private let yoloObjectLabel_ja = [
    "人","自転車","車","バイク","飛行機","バス","電車","トラック","ボート","信号機",
    "消火栓","停止","パーキングメーター","ベンチ","鳥","猫","犬","馬","羊","牛",
    "ゾウ","クマ","ゼブラ","キリン","バックパック","傘","ハンドバッグ","ネクタイ","スーツケース","フリスビー",
    "スキー","スノーボード","スポーツボール","タコ","バット","グローブ","スケートボード","サーフボード","テニスラケット","ボトル",
    "ワイングラス","カップ","フォーク","ナイフ","スプーン","ボール","バナナ","アップル","サンドイッチ","オレンジ",
    "ブロッコリー","にんじん","ホットドッグ","ピザ","ドーナツ","ケーキ","チェア","ソファー","鉢植え","ベッド",
    "ダイニングテーブル","トイレ","テレビモニター","ノートパソコン","マウス","リモコン","キーボード","携帯電話","電子レンジ","オーブン",
    "トースター","流し台","冷蔵庫","本","時計","花瓶","はさみ","テディベア","ヘアドライヤー","歯ブラシ"
]

private let yoloObjectLabel_en = [
    "person", "bicycle", "car", "motorbike", "aeroplane", "bus", "train", "truck", "boat", "traffic light",
    "fire hydrant", "stop sign", "parking meter", "bench", "bird", "cat", "dog", "horse", "sheep", "cow",
    "elephant", "bear", "zebra", "giraffe", "backpack", "umbrella", "handbag", "tie", "suitcase", "frisbee",
    "skis", "snowboard", "sports ball", "kite", "baseball bat", "baseball glove", "skateboard", "surfboard", "tennis racket", "bottle",
    "wine glass", "cup", "fork", "knife", "spoon", "bowl", "banana", "apple", "sandwich", "orange",
    "broccoli", "carrot", "hot dog", "pizza", "donut", "cake", "chair", "sofa", "pottedplant", "bed",
    "diningtable", "toilet", "tvmonitor", "laptop", "mouse", "remote", "keyboard", "cell phone", "microwave", "oven",
    "toaster", "sink", "refrigerator", "book", "clock", "vase", "scissors", "teddy bear", "hair drier", "toothbrush"
]

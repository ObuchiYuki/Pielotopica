//
//  YOLO.swift
//  TPCaptureScene
//
//  Created by yuki on 2019/07/11.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import UIKit
import CoreML

private let anchors: [[Float]] = [
    [116,90,  156,198,  373,326],
    [30,61,  62,45,  59,119],
    [10,13,  16,30,  33,23]
]

public class YOLO {
    
    // ===================================================================== //
    // MARK: - Properties -
    public static let inputWidth = 416
    public static let inputHeight = 416
    public static let maxBoundingBoxes = 10
    
    /// 確証度の閾値です。
    /// confidenceThreshold をあげれば、認識される物体数は減少します。
    var confidenceThreshold: Float = 0.7
    
    /// IOU(物体の重複を防ぐ)の閾値です。
    /// iouThresholdを下げれば、物体の重複認識は減ります。
    var iouThreshold: Float = 0.3
     
    public struct Prediction {
        public let classIndex: Int
        public let score: Float
        public let rect: CGRect
    }
    
    let model = Yolov3()
    
    // ===================================================================== //
    // MARK: - Methods -
    
    /// バッファーに入ってきた画像を同期的に解析します。
    public func predict(image: CVPixelBuffer) -> [Prediction] {
        
        if let output = try? model.prediction(input1: image) {
            return computeBoundingBoxes(features: [output.output1, output.output2, output.output3])
        } else {
            return []
        }
    }
    
    /** Input YOLO
     
     出力は縦横が13x13、26x26、52x52の3種類のテンソルが3つ出力となります。
     このサイズは入力の416x416をそれぞれ(1/32)、(1/16)、(1/8)としたものになります。
     各グリッドは5つ（boxesPerCell）の枠を計算します。
     
     また、各セルは[3x(4+1+80)]のサイズのベクトルになっており、
     [(3週類のpriorのサイズ)x((横位置tx, 縦位置ty, 横幅tw, 縦幅th), 物体の存在確率 Objectness score, 各クラスの所属確率)]
     に対応します。
     
     メモ： `features[[channel, cy, cx] as [NSNumber]].floatValue` のように
     Float値にアクセスするのは低速です。
     メモリに直接アクセスしてください。
     */
    public func computeBoundingBoxes(features: [MLMultiArray]) -> [Prediction] {
        /// Checks for output size
        assert(features[0].count == 255*13*13)
        assert(features[1].count == 255*26*26)
        assert(features[2].count == 255*52*52)
        
        var predictions = [Prediction]()
        
        let blockSize: Float = 32
        let boxesPerCell = 3
        let numClasses = 80
        
        var gridHeight = [13, 26, 52]
        var gridWidth = [13, 26, 52]
        
        var featurePointer = UnsafeMutablePointer<Double>(OpaquePointer(features[0].dataPointer))
        var channelStride = features[0].strides[0].intValue
        var yStride = features[0].strides[1].intValue
        var xStride = features[0].strides[2].intValue
        
        func offset(_ channel: Int, _ x: Int, _ y: Int) -> Int {
            return channel*channelStride + y*yStride + x*xStride
        }
        
        for i in 0..<3 {
            featurePointer = UnsafeMutablePointer<Double>(OpaquePointer(features[i].dataPointer))
            channelStride = features[i].strides[0].intValue
            yStride = features[i].strides[1].intValue
            xStride = features[i].strides[2].intValue
            
            for cy in 0..<gridHeight[i] {
                for cx in 0..<gridWidth[i] {
                    for b in 0..<boxesPerCell {
                        // 最初のバウンディングボックス（b = 0）では、チャンネル0〜24を読み取る必要があり、
                        // b = 1では、チャンネル25〜49を読み取る必要があります。
                        let channel = b*(numClasses + 5)
                        
                        // 多分これが一番早いと思います。
                        let tx = Float(featurePointer[offset(channel    , cx, cy)])
                        let ty = Float(featurePointer[offset(channel + 1, cx, cy)])
                        let tw = Float(featurePointer[offset(channel + 2, cx, cy)])
                        let th = Float(featurePointer[offset(channel + 3, cx, cy)])
                        let tc = Float(featurePointer[offset(channel + 4, cx, cy)])
                        
                        let scale = powf(2.0,Float(i))
                        let x = (Float(cx) * blockSize + sigmoid(tx))/scale
                        let y = (Float(cy) * blockSize + sigmoid(ty))/scale
                        
                        let w = exp(tw) * anchors[i][2*b    ]
                        let h = exp(th) * anchors[i][2*b + 1]
                        
                        let confidence = sigmoid(tc)
                        
                        var classes = [Float](repeating: 0, count: numClasses)
                        for c in 0..<numClasses {
                            classes[c] = Float(featurePointer[offset(channel + 5 + c, cx, cy)])
                        }
                        classes = softmax(classes)
                        
                        let (detectedClass, bestClassScore) = classes.argmax()
                        
                        let confidenceInClass = bestClassScore * confidence
                        
                        if confidenceInClass > confidenceThreshold {
                            let rect = CGRect(x: CGFloat(x - w/2), y: CGFloat(y - h/2), width: CGFloat(w), height: CGFloat(h))
                            
                            let prediction = Prediction(classIndex: detectedClass, score: confidenceInClass, rect: rect)
                            predictions.append(prediction)
                        }
                    }
                }
            }
        }
        
        return nonMaxSuppression(boxes: predictions, limit: YOLO.maxBoundingBoxes, threshold: iouThreshold)
    }
}


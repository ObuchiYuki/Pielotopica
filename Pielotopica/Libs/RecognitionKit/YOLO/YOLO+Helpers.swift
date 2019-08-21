//
//  YOLO+Helpers.swift
//  TPCaptureScene
//
//  Created by yuki on 2019/05/11.
//  Copyright © 2019 yuki. All rights reserved.
//


import Foundation
import UIKit
import CoreML
import Accelerate


/// IOUアルゴリズムを用いて、閾値以上の重複のあるRectを省きます。
/// (ちょっと遅い、改善の余地あり？)
///
/// - Parameter boxes: 認識結果を渡してください。
/// - Parameter limit: Boxの最大数を渡してください。
/// - Parameter threshold: IOUの閾値を渡してください。
func nonMaxSuppression(boxes: [YOLO.Prediction], limit: Int, threshold: Float) -> [YOLO.Prediction] {
    
    let sortedIndices = boxes.indices.sorted { boxes[$0].score > boxes[$1].score }
    
    var selected: [YOLO.Prediction] = []
    var active = [Bool](repeating: true, count: boxes.count)
    var numActive = active.count
    
    let c = boxes.count
    outer: for i in 0..<c{
        if active[i] {
            let boxA = boxes[sortedIndices[i]]
            selected.append(boxA)
            if selected.count >= limit { break }
            
            for j in i+1..<c {
                if active[j] {
                    let boxB = boxes[sortedIndices[j]]
                    if IOU(a: boxA.rect, b: boxB.rect) > threshold {
                        active[j] = false
                        numActive -= 1
                        if numActive <= 0 { break outer }
                    }
                }
            }
        }
    }
    return selected
}

/// 2つのRectのIOU値を返します。
public func IOU(a: CGRect, b: CGRect) -> Float {
    let areaA = a.width * a.height
    if areaA <= 0 { return 0 }
    
    let areaB = b.width * b.height
    if areaB <= 0 { return 0 }
    
    let intersectionMinX = max(a.minX, b.minX)
    let intersectionMinY = max(a.minY, b.minY)
    let intersectionMaxX = min(a.maxX, b.maxX)
    let intersectionMaxY = min(a.maxY, b.maxY)
    let intersectionArea = max(intersectionMaxY - intersectionMinY, 0) * max(intersectionMaxX - intersectionMinX, 0)
    
    return Float(intersectionArea / (areaA + areaB - intersectionArea))
}

extension Array where Element: Comparable {
    
    internal func argmax() -> (Int, Element) {
        
        var maxIndex = 0
        var maxValue = self[0]
        let c = self.count
        
        for i in 1..<c{
            if self[i] > maxValue {
                maxValue = self[i]
                maxIndex = i
            }
        }
        
        return (maxIndex, maxValue)
    }
}

/// sigmoidの実装
internal func sigmoid(_ x: Float) -> Float {
    return 1 / (1 + exp(-x))
}

/// Copied from
/// https://github.com/nikolaypavlov/MLPNeuralNet/
public func softmax(_ x: [Float]) -> [Float] {
    var x = x
    let len = vDSP_Length(x.count)
    
    // Find the maximum value in the input array.
    var max: Float = 0
    vDSP_maxv(x, 1, &max, len)
    
    // Subtract the maximum from all the elements in the array.
    // Now the highest value in the array is 0.
    max = -max
    vDSP_vsadd(x, 1, &max, &x, 1, len)
    
    // Exponentiate all the elements in the array.
    var count = Int32(x.count)
    vvexpf(&x, x, &count)
    
    // Compute the sum of all exponentiated values.
    var sum: Float = 0
    vDSP_sve(x, 1, &sum, len)
    
    // Divide each element by the sum. This normalizes the array contents
    // so that they all add up to 1.
    vDSP_vsdiv(x, 1, &sum, &x, 1, len)
    
    return x
}


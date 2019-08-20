//
//  RKObjectDetector.swift
//  YOLOv3-CoreML
//
//  Created by yuki on 2019/07/11.
//  Copyright © 2019 MachineThink. All rights reserved.
//

import UIKit

public protocol RKObjectDetectorDelegate:class {
    func detector(_ detector:RKObjectDetector, didDetectObjectsWith predictions:[RKObjectDetector.Prediction])
}

// =============================================================== //
// MARK: - RKObjectDetector -

/**
 画像を認識し、結果を返します。
 */
public class RKObjectDetector {
    // =============================================================== //
    // MARK: - Properties -
    /// delegate of RKObjectDetector
    public weak var delegate:RKObjectDetectorDelegate?
    
    /// confidenceThreshold をあげれば、認識される物体の確度が上がります。(認識されるものの数は減ります。)
    /// default = 0.7
    public var confidenceThreshold: Float {
        get { return yolo.confidenceThreshold }
        set {yolo.confidenceThreshold = newValue}
    }
    
    /// iouThresholdを下げれば、物体の重複認識は減ります。(近くにあるものが省略される可能性が上がります。)
    /// default = 0.3
    public var iouThreshold: Float {
        get { return yolo.iouThreshold }
        set {yolo.iouThreshold = newValue}
    }
    
    // =============================================================== //
    // MARK: - Private Properties -
    
    private let yolo = YOLO()
    private let imageResizer = RKImageResizer()
    private let nameMapper = RKObjectNameMapper()
    
    // =============================================================== //
    // MARK: - Methods -
    
    /// 認識オブジェクトの翻訳を選択させます。
    public enum Region {
        case japanese
        case english
    }
    
    public func predictObjects(from pixelBuffer:CVPixelBuffer,for region: Region = .japanese) {
        let resizedPixelBuffer = imageResizer.resize(pixelBuffer: pixelBuffer)
        
        let predictions = yolo.predict(image: resizedPixelBuffer).map {
            Prediction(
                name: nameMapper.name(at: $0.classIndex, for: region),
                confidence: $0.score * 100,
                rect: $0.rect ,
                classIndex: $0.classIndex
            )
        }
        
        DispatchQueue.main.async {
            self.delegate?.detector(self, didDetectObjectsWith: predictions)
        }
    }
}

extension RKObjectDetector {
    /// 認識結果を表します。
    public struct Prediction{
        
        static private let rectAdjuster = RKRectAdjuster()
        // =============================================================== //
        // MARK: - Properties -
        /// 対象物の名称です。
        let name:String
        /// 認識の確度です。
        let confidence:Float
        /// YOLOの画像認識番号です。
        let classIndex:Int
        
        // =============================================================== //
        // MARK: - Methods -
        func rect(for sizeOfView: CGSize) -> CGRect {
            return Prediction.rectAdjuster.adjestRect(_rect, with: sizeOfView)
        }
        
        // =============================================================== //
        // MARK: - Private Properties -
        /// 認識された物体の枠です。
        private let _rect:CGRect
        
        // =============================================================== //
        // MARK: - Constructor -
        init(name:String, confidence:Float, rect:CGRect, classIndex:Int) {
            self.name = name
            self.confidence = confidence
            self._rect = rect
            self.classIndex = classIndex
        }
    }
}

//
//  CRObjectDetector.swift
//  YOLOv3-CoreML
//
//  Created by yuki on 2019/07/11.
//  Copyright © 2019 MachineThink. All rights reserved.
//

import UIKit

public protocol CRObjectDetectorDelegate:class {
    func detector(_ detector:CRObjectDetector, didDetectObjectsWith predictions:[CRObjectDetector.Prediction])
}

// =============================================================== //
// MARK: - CRObjectDetector -

/**
 画像認識の一番外側のラッパークラスです。
 
 */
public class CRObjectDetector {
    // =============================================================== //
    // MARK: - Properties -
    public weak var delegate:CRObjectDetectorDelegate?
    
    // =============================================================== //
    // MARK: - Private Properties -
    
    private let yolo = YOLO()
    private let imageResizer = CRImageResizer()
    private let nameMapper = CRObjectNameMapper()
    
    // =============================================================== //
    // MARK: - Methods -
    func predictObjects(from pixelBuffer:CVPixelBuffer) {
        let resizedPixelBuffer = imageResizer.resize(pixelBuffer: pixelBuffer)
        
        let predictions = yolo.predict(image: resizedPixelBuffer).map {
            Prediction(
                name: nameMapper.name_jp(for: $0.classIndex),
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

extension CRObjectDetector {
    /// 認識結果を表します。
    public struct Prediction{
        
        static private let rectAdjuster = CRRectAdjuster()
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

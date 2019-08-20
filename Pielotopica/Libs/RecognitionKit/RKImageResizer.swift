//
//  RKImageResizer.swift
//  YOLOv3-CoreML
//
//  Created by yuki on 2019/07/11.
//  Copyright © 2019 MachineThink. All rights reserved.
//

import CoreGraphics
import CoreImage

// =============================================================== //
// MARK: - CRImageResizer -

/**
 */
internal class RKImageResizer {

    // =============================================================== //
    // MARK: - Private Properties -
    private let ciContext = CIContext()
    private var resizedPixelBuffer: CVPixelBuffer?
    
    // =============================================================== //
    // MARK: - Methods -
    func resize(pixelBuffer:CVPixelBuffer) -> CVPixelBuffer {
        guard let resizedPixelBuffer = resizedPixelBuffer else {
            fatalError("CVPixelBuffer is not initilizad. Check the flow of constructor.")
        }
        
        let resizedImage = _resizeImage(from: pixelBuffer)
        
        ciContext.render(resizedImage, to: resizedPixelBuffer)
     
        return resizedPixelBuffer
    }
    // =============================================================== //
    // MARK: - Constructor -
    init() {
        _setUpCoreImage()
    }
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    /// 画像をリサイズします。
    private func _resizeImage(from pixelBuffer:CVPixelBuffer) -> CIImage {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let sx = CGFloat(YOLO.inputWidth) / CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let sy = CGFloat(YOLO.inputHeight) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
        let scaledImage = ciImage.transformed(by: scaleTransform)
        
        return scaledImage
    }
    
    
    /// CGContextを初期化します。
    private func _setUpCoreImage() {
        let status = CVPixelBufferCreate(
            nil, YOLO.inputWidth, YOLO.inputHeight,
            kCVPixelFormatType_32BGRA, nil,
            &resizedPixelBuffer
        )
        if status != kCVReturnSuccess {
            print("Error: could not create resized pixel buffer", status)
        }
    }
}

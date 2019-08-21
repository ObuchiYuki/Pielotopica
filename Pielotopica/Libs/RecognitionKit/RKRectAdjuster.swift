//
//  RKRectAdjuster.swift
//  YOLOv3-CoreML
//
//  Created by yuki on 2019/07/11.
//  Copyright © 2019 yuki. All rights reserved.
//

import CoreGraphics

// =============================================================== //
// MARK: - CRRectAdjuster -

/**
 */
class RKRectAdjuster {
    // =============================================================== //
    // MARK: - Methods -
    
    func adjestRect(_ rect:CGRect, with viewSize:CGSize) -> CGRect {
        let width = viewSize.width
        let height = width * 4 / 3
        let scaleX = width / CGFloat(YOLO.inputWidth)
        let scaleY = height / CGFloat(YOLO.inputHeight)
        let top = (viewSize.height - height) / 2
        
        var rect = rect
        rect.origin.x *= scaleX
        rect.origin.y *= scaleY
        rect.origin.y += top
        rect.size.width *= scaleX
        rect.size.height *= scaleY
        
        return rect
    }
}

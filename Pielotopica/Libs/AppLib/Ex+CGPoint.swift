//
//  Ex+[CGPoint].swift
//  Pielotopica
//
//  Created by yuki on 2019/08/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import CoreGraphics
import Foundation

func abs(_ point: CGPoint) -> CGFloat {
    return sqrt(point.x * point.x + point.y * point.y)
}

extension CGPoint {
    static func random(x xrange: ClosedRange<CGFloat>, y yrange: ClosedRange<CGFloat>) -> CGPoint {
        return CGPoint(x: CGFloat.random(in: xrange), y: CGFloat.random(in: yrange))
    }
    
    func isNear(to point:CGPoint, distanceThreshold:CGFloat = 0.2) -> Bool {
        self.distance(from: point) < distanceThreshold
    }
    var normarized: CGPoint {
        let a = abs(self)
        guard a != 0 else { return .zero }
        
        return CGPoint(x: self.x / a, y: self.y / a)
    }
}


extension Array where Element == CGPoint {
    func split(stride:CGFloat) -> [CGPoint] {
        if self.count <= 1 {return self}
        var points = [CGPoint]()
        
        func nor(a:CGPoint, b: CGPoint, d:CGFloat) -> CGPoint { (b - a) / d * stride }
        
        for i in 0..<self.count-1 {
            let d = self[i].distance(from: self[i+1])
            let n = nor(a: self[i], b: self[i+1], d: d)
            let c = Int(d / stride)
            for _ in 0..<c { points.append(n) }
            points.append(self[i+1] - self[i] - n * c)
        }
        
        return points
    }
}

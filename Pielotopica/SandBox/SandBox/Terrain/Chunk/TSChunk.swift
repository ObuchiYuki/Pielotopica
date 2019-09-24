//
//  TSChunk.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
 
/// (x, y, z) = (16, 4, 16)
/// = 1024 blocks
public class TSChunk {
    // MARK: - Properties -
    
    public var isEdited = false
    
    public var point = TSChunkPoint.zero
    
    /// local
    internal var fillmap:[[[UInt16]]] =
        Array(repeating: Array(repeating: Array(repeating: 0, count: TSChunk.sideWidth), count: TSChunk.height), count: TSChunk.sideWidth)
    
    /// local
    internal var datamap:[[[UInt8]]] =
        Array(repeating: Array(repeating: Array(repeating: 0, count: TSChunk.sideWidth), count: TSChunk.height), count: TSChunk.sideWidth)
    
    /// global
    internal var fillAnchors:[[[TSVector3]]] =
        Array(repeating: Array(repeating: Array(repeating: .zero, count: TSChunk.sideWidth), count: TSChunk.height), count: TSChunk.sideWidth)
        
    /// local
    internal var anchors     = Set<TSVector3>()

    // MARK: - Methods -
    
    public func getFillBlock(at chunkPoint: TSVector3) -> TSBlock {
        let (x, y, z) = chunkPoint.tuple
        let blockIndex = fillmap[x][y][z]
            
        return TSBlock.block(for: blockIndex)
    }
    
    public func getRotation(at chunkPoint: TSVector3) -> TSBlockRotation {
        return TSBlockRotation(data: getBlockData(at: chunkPoint))
    }
    
    public func getBlockData(at chunkPoint: TSVector3) -> TSBlockData {
        let (x, y, z) = chunkPoint.tuple
        let blockData = datamap[x][y][z]
        
        return TSBlockData(value: blockData)
    }
    
    public func getAnchorPoint(ofFill chunkPoint: TSVector3) -> TSVector3? {
        let (x, y, z) = chunkPoint.tuple
        
        return fillAnchors[x][y][z]
    }
    
    public func getAnchors() -> Set<TSVector3> {
        return anchors
    }
    
    public func makeGlobal(_ chunkPoint: TSVector3) -> TSVector3 {
        return self.point.vector3(y: 0) + chunkPoint
    }
}

extension TSChunk {
    public static let sideWidth: Int = 16
    public static let height: Int = 4
    
}

extension TSChunk: Equatable {
    public static func == (left: TSChunk, right: TSChunk) -> Bool {
        return left.point == right.point
    }
}

extension TSChunk: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(point)
    }
}

extension TSChunk: CustomStringConvertible {
    public func layerDescription(y: Int16) -> String {
        var u = ""
        u += "\nLayer \(y)\nx\\z|"
        for i in 0..<TSChunk.sideWidth {
            u += String(format: "%02d,", i)
        }
        u += "\n___|"
        for _ in 0..<TSChunk.sideWidth {
            u += "___"
        }
        u += "\n"
        
        for x in 0..<TSChunk.sideWidth.i {
            u += "\(String(format: "%02d ", x))|"
            for z in 0..<TSChunk.sideWidth.i {
                u += String(format: "%02d,", self.fillmap[x][y.i][z])
            }
            u += "\n"
        }
        
        return u
    }
    public var description: String {
        var u = ""
        for y in 0..<TSChunk.height  {
            u += layerDescription(y: Int16(y))
        }
        
        return u
    }
}

extension TSChunk {
    static func convertToChunkPoint(fromGlobal point: TSVector2) -> TSChunkPoint {
        return TSChunkPoint(point.x16 / Int16(TSChunk.sideWidth), point.z16 / Int16(TSChunk.sideWidth))
    }
    
    static func convertToChunkPosition(fromGlobal globalPoint: TSVector3) -> TSVector3 {
        let chunkPoint = convertToChunkPoint(fromGlobal: globalPoint.vector2).vector3(y: 0)
        
        let position = (globalPoint - chunkPoint).positive
        
        return position
    }
}

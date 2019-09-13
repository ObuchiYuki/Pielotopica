//
//  TSLevelFileLoader.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import BoxData

private struct _TSChunkData: Codable {
    init(chunk: TSChunk) {
        
    }
}


class TSLevelFileLoader {
    static let shared = TSLevelFileLoader()
    
    private static var encoder: BoxEncoder {
        let _encoder = BoxEncoder()
        _encoder.compressionLevel = 2
        return _encoder
    }
    
    private static let decoder = BoxDecoder()
    
    @discardableResult
    static func saveChunk(_ chunk:TSChunk, for point: TSChunkPoint) -> Bool {
        let _data = _TSChunkData(chunk: chunk)
        
        do {
            let data = try encoder.encode(_data)
            _saveData(data, at: point)
        } catch {
            log.error(error)
            return false
        }
        
        return true
    }
    
    static func loadChunk(at point:TSChunkPoint) -> TSChunk {
        
    }
    
    @inline(__always)
    private static func _saveData(_ data: Data, at point: TSChunkPoint) {
        let name
    }
    
    
    @inline(__always)
    private static func _filename(of point: TSChunkPoint) -> String {
        let name = "r.\(point.x).\(point.z).box"
        
        return name
    }
}

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
    
    var chunk:TSChunk
}

 
public class TSLevelFileLoader {
    public static let shared = TSLevelFileLoader()
    
    private var encoder: BoxEncoder {
        let _encoder = BoxEncoder()
        _encoder.compressionLevel = 2
        return _encoder
    }
    
    private let decoder = BoxDecoder()
    
    @discardableResult
    public func saveChunk(_ chunk:TSChunk, for point: TSChunkPoint) -> Bool {
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
    
    public func loadChunk(at point:TSChunkPoint) -> TSChunk? {
        guard var url = _prepareDirectory() else { return nil }
        
        url.appendPathComponent(_filename(of: point))
        
        guard let data = FileManager.default.contents(atPath: url.path) else { return nil }
        
        do {
            let _data = try decoder.decode(_TSChunkData.self, from: data)
            return _data.chunk
            
        }catch {
            log.error(error)
        }
        
        return nil
    }
    
    private func _saveData(_ data: Data, at point: TSChunkPoint) {
        guard var url = _prepareDirectory() else {return}
        
        url.appendPathComponent(_filename(of: point))
        
        FileManager.default.createFile(atPath: url.path, contents: data)
    }
    
    private func _prepareDirectory() -> URL? {
        guard var documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            log.error("Error in finding documentDirectory.")
            return nil
        }
        documentDir.appendPathComponent("Region")
        
        if !FileManager.default.fileExists(atPath: documentDir.path) {
            do {
                try FileManager.default.createDirectory(at: documentDir, withIntermediateDirectories: false)
            } catch {
                log.error(error)
            }
        }
        
        return documentDir
    }
    private func _filename(of point: TSChunkPoint) -> String {
        return "r.\(point.x).\(point.z).box"
    }
}

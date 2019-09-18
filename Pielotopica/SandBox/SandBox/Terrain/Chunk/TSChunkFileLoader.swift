//
//  TSLevelFileLoader.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import BoxData

 
public class TSChunkFileLoader {
    public static let shared = TSChunkFileLoader()
    
    private var encoder: BoxEncoder {
        let _encoder = BoxEncoder()
        _encoder.compressionLevel = 0
        _encoder.useStructureCache = false
        return _encoder
    }
    
    private let decoder = BoxDecoder()
    
    public func saveChunk(_ chunk:TSChunk) {
        
        DispatchQueue.global(qos: .background).async {
            let _data = _TSChunkData(chunk: chunk)
            
            do {
                let data = try self.encoder.encode(_data)
                self._saveData(data, at: chunk.point)
            } catch {
                log.error(error)
                return
            }
        }
    }
    
    public func loadChunk(at point:TSChunkPoint) -> TSChunk? {
        guard var url = _prepareDirectory() else { return nil }
        
        url.appendPathComponent(_filename(of: point))
        
        guard let data = FileManager.default.contents(atPath: url.path) else { return nil }
        
        do {
            let _data = try decoder.decode(_TSChunkData.self, from: data)
            let chunk = _data.chunk
            chunk.point = point
            
            return chunk
            
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

private struct _TSChunkData: Codable {
    
    /// 16 x 4 x 16 = 1024 size arrays
    var anchors: Set<TSVector3>
    var fillmap       = [UInt16?](repeating: nil, count: 1024)
    var fillAnchormap = [TSVector3?](repeating: nil, count: 1024)
    var datamap       = [UInt8?](repeating: nil, count: 1024)
    
    var chunk:TSChunk {
        let chunk = TSChunk()
        
        for x in 0..<Int(TSChunk.sideWidth) {
            for y in 0..<Int(TSChunk.height) {
                for z in 0..<Int(TSChunk.sideWidth) {
                    let index = x * Int(TSChunk.height * TSChunk.sideWidth) + y * Int(TSChunk.sideWidth) + z
                    
                    chunk.anchors = anchors
                    chunk.fillmap[x][y][z] = fillmap[index]!
                    chunk.fillAnchors[x][y][z] = fillAnchormap[index]!
                    chunk.datamap[x][y][z] = datamap[index]!
                    
                }
            }
        }
        
        return chunk
    }
    
    init(chunk: TSChunk) {
        
        anchors = chunk.anchors
        
        for x in 0..<Int(TSChunk.sideWidth) {
            for y in 0..<Int(TSChunk.height) {
                for z in 0..<Int(TSChunk.sideWidth) {
                    let index = x * Int(TSChunk.height * TSChunk.sideWidth) + y * Int(TSChunk.sideWidth) + z
                    
                    fillmap[index]          = chunk.fillmap[x][y][z]
                    fillAnchormap[index]    = chunk.fillAnchors[x][y][z]
                    datamap[index]          = chunk.datamap[x][y][z]

                }
            }
        }
    }
}

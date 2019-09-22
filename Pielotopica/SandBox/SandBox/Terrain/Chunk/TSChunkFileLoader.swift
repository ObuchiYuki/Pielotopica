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

    public func saveChunkSync_Async(_ chunk: TSChunk) {
        do {
            let data = try _TSChunkSerialization.data(from: chunk)
            self._saveData(data, at: chunk.point)
        } catch {
            log.error(error)
            return
        }
    }
    
    public func loadChunkAsync(at point: TSChunkPoint, _ completion: @escaping (TSChunk?)->() ) {
        DispatchQueue.global(qos: .userInteractive).async {
            let chunk = self.loadChunkSync(at: point)
            
            DispatchQueue.main.async {
                completion(chunk)
            }
        }
    }
    
    public func loadChunkSync(at point:TSChunkPoint) -> TSChunk? {
        guard var url = _prepareDirectory() else { return nil }
        url.appendPathComponent(_filename(of: point))
        guard let data = FileManager.default.contents(atPath: url.path) else { return nil }
        
        do {
            let chunk = try _TSChunkSerialization.chunk(from: data, at: point)
                        
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

/**
 # Layer Format

 - `TSVector3`: x: Int16, Int16, Int16 (aka 6 bytes)

 ### Data Structures -
 
 - Header: `'L'` (aka `0x4c`)
 - anchors: `size: (UInt16) TSVector3...`
 - fillmap, fillAnchormap, datamap: `UInt16[1024]`, `TSVector3[1024]`, `UInt8[1024]`

 */
private class _TSChunkSerialization {
    
    static func data(from chunk: TSChunk) throws -> Data {
        let stream = ChunkDataWriteStream()
        
        try stream.write(UInt16(chunk.anchors.count))
        
        for anchor in chunk.anchors {
            try stream.write(anchor)
        }
        
        for x in 0..<Int(TSChunk.sideWidth) {
            for y in 0..<Int(TSChunk.height) {
                for z in 0..<Int(TSChunk.sideWidth) {
                    try stream.write(chunk.fillmap[x][y][z])
                    try stream.write(chunk.fillAnchors[x][y][z])
                    try stream.write(chunk.datamap[x][y][z])
                }
            }
        }
        
        guard stream.data != nil else{ throw ChunkDataStreamError.writeError }
        
        return stream.data!
    }
    
    static func chunk(from data: Data, at point: TSChunkPoint) throws -> TSChunk {
        let stream = ChunkDataReadStream(data: data)
        
        let chunk = TSChunk()
        chunk.point = point
        
        let anchorCount = try stream.uint16()

        for _ in 0..<anchorCount {
            chunk.anchors.insert(try stream.vector3())
        }
        
        for x in 0..<Int(TSChunk.sideWidth) {
            for y in 0..<Int(TSChunk.height) {
                for z in 0..<Int(TSChunk.sideWidth) {
                    chunk.fillmap[x][y][z] = try stream.uint16()
                    chunk.fillAnchors[x][y][z] = try stream.vector3()
                    chunk.datamap[x][y][z] = try stream.uInt8()
                }
            }
        }
        
        return chunk
    }
}

enum ChunkDataStreamError: Error {
    case readError
    case writeError
}


@usableFromInline
internal class ChunkDataReadStream {

    private var inputStream: InputStream
    private let bytes: Int
    private var offset: Int = 0
    
    init(data: Data) {
        self.inputStream = InputStream(data: data)
        self.inputStream.open()
        self.bytes = data.count
    }

    deinit {
        self.inputStream.close()
    }

    var hasBytesAvailable: Bool {
        return self.inputStream.hasBytesAvailable
    }
    
    var bytesAvailable: Int {
        return self.bytes - self.offset
    }
    
    func readBytes<T>() throws -> T {
        let valueSize = MemoryLayout<T>.size
        let valuePointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
        var buffer = [UInt8](repeating: 0, count: MemoryLayout<T>.stride)
        let bufferPointer = UnsafeMutablePointer<UInt8>(&buffer)
        if self.inputStream.read(bufferPointer, maxLength: valueSize) != valueSize {
            
            throw ChunkDataStreamError.readError
        }
        bufferPointer.withMemoryRebound(to: T.self, capacity: 1) {
            valuePointer.pointee = $0.pointee
        }
        offset += valueSize
        return valuePointer.pointee
    }
    
    func vector3() throws -> TSVector3 {
        return TSVector3(try int16(), try int16(), try int16())
    }

    func uInt8() throws -> UInt8 {
        return try self.readBytes()
    }

    func int16() throws -> Int16 {
        let value:UInt16 = try self.readBytes()
        return Int16(bitPattern: CFSwapInt16BigToHost(value))
    }
    func uint16() throws -> UInt16 {
        let value:UInt16 = try self.readBytes()
        return CFSwapInt16BigToHost(value)
    }
}

@usableFromInline
internal class ChunkDataWriteStream {

    private var outputStream: OutputStream

    init() {
        self.outputStream = OutputStream.toMemory()
        self.outputStream.open()
    }

    deinit {
        self.outputStream.close()
    }

    var data: Data? {
        return self.outputStream.property(forKey: .dataWrittenToMemoryStreamKey) as? Data
    }
    
    func writeBytes<T>(value: T) throws {
        let valueSize = MemoryLayout<T>.size
        var value = value
        var result = 0
        
        let valuePointer = UnsafeMutablePointer<T>(&value)
        _ = valuePointer.withMemoryRebound(to: UInt8.self, capacity: valueSize) {
            result = outputStream.write($0, maxLength: valueSize)
        }
            
        if result < 0 {
            throw ChunkDataStreamError.writeError
        }
    }

    func write(_ value: Int8) throws {
        try writeBytes(value: value)
    }
    func write(_ value: UInt8) throws {
        try writeBytes(value: value)
    }

    func write(_ value: Int16) throws {
        try writeBytes(value: CFSwapInt16HostToBig(UInt16(bitPattern: value)))
    }
    func write(_ value: UInt16) throws {
        try writeBytes(value: CFSwapInt16HostToBig(value))
    }

    func write(_ value: TSVector3) throws {
        try write(value.x16)
        try write(value.y16)
        try write(value.z16)
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

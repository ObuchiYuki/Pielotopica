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
        let data = _TSChunkSerialization.data(from: chunk)
        self._saveData(data, at: chunk.point)
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
        
        let chunk = _TSChunkSerialization.chunk(from: data, at: point)
        return chunk
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
    
    static func data(from chunk: TSChunk) -> Data {
        let stream = ChunkDataWriteStream()
        
        stream.write(UInt16(chunk.anchors.count))
        
        for anchor in chunk.anchors {
            stream.write(anchor)
        }
        
        for x in 0..<TSChunk.sideWidth {
            for y in 0..<TSChunk.height {
                for z in 0..<TSChunk.sideWidth {
                    stream.write(chunk.fillmap[x][y][z])
                    stream.write(chunk.fillAnchors[x][y][z]!)
                    stream.write(chunk.datamap[x][y][z])
                }
            }
        }
        
        return stream.data!
    }
    
    static func chunk(from data: Data, at point: TSChunkPoint) -> TSChunk {
        let stream = ChunkDataReadStream(data: data)
        
        let chunk = TSChunk()
        chunk.point = point
        
        let anchorCount = stream.uint16()

        for _ in 0..<anchorCount {
            chunk.anchors.insert(stream.vector3())
        }
        
        let _o_loadChunk = RMMeasure()
        for x in 0..<TSChunk.sideWidth {
            for y in 0..<TSChunk.height {
                for z in 0..<TSChunk.sideWidth {
                    chunk.fillmap[x][y][z] = stream.uint16()
                    chunk.fillAnchors[x][y][z] = stream.vector3()
                    chunk.datamap[x][y][z] = stream.uInt8()
                }
            }
        }
        _o_loadChunk.end()
        
        
        return chunk
    }
}


@usableFromInline
internal class ChunkDataReadStream {
    
    private var inputStream: InputStream
    
    @usableFromInline
    init(data: Data) {
        self.inputStream = InputStream(data: data)
        self.inputStream.open()
    }

    @usableFromInline
    deinit {
        self.inputStream.close()
    }
    
    @inline(__always)
    func readBytes<T>(_ valueSize:Int) -> T {
        let valuePointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
        var buffer = [UInt8](repeating: 0, count: MemoryLayout<T>.stride)
        let bufferPointer = UnsafeMutablePointer<UInt8>(&buffer)
        
        self.inputStream.read(bufferPointer, maxLength: valueSize)
        
        bufferPointer.withMemoryRebound(to: T.self, capacity: 1) {
            valuePointer.pointee = $0.pointee
        }
        return valuePointer.pointee
    }
    
    @inline(__always)
    func vector3() -> TSVector3 {
        return TSVector3(int16(), int16(), int16())
    }

    @inline(__always)
    func uInt8() -> UInt8 {
        return self.readBytes(1)
    }

    @inline(__always)
    func int16() -> Int16 {
        return Int16(bitPattern: self.readBytes(2))
    }
    
    @inline(__always)
    func uint16() -> UInt16 {
        return self.readBytes(2)
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
    
    func writeBytes<T>(value: T) {
        let valueSize = MemoryLayout<T>.size
        var value = value
        
        let valuePointer = UnsafeMutablePointer<T>(&value)
        _ = valuePointer.withMemoryRebound(to: UInt8.self, capacity: valueSize) {
            outputStream.write($0, maxLength: valueSize)
        }
    }

    func write(_ value: Int8) {
        writeBytes(value: value)
    }
    func write(_ value: UInt8) {
        writeBytes(value: value)
    }

    func write(_ value: Int16) {
        writeBytes(value: UInt16(bitPattern: value))
    }
    func write(_ value: UInt16) {
        writeBytes(value: value)
    }

    func write(_ value: TSVector3) {
        write(value.x16)
        write(value.y16)
        write(value.z16)
    }
}

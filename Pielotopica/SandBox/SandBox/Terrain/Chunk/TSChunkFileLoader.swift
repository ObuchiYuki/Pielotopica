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
    
    private var encoder: BoxEncoder = {
        let encoder = BoxEncoder()

        return encoder
    }()
    
    private let decoder = BoxDecoder()
    
    public func saveChunkSync_Async(_ chunk: TSChunk) {
        let _data = _TSChunkData(chunk: chunk)
        
        do {
            let data = try self.encoder.encode(_data)
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
            let start = Date()
            let _data = try decoder.decode(_TSChunkData.self, from: data)
            print(Date().timeIntervalSince(start), "s")
            
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

/**
 # Layer Format

 - `TSVector3`: x: Int16, Int16, Int16 (aka 6 bytes)

 ### Data Structures -
 
 - Header: `'L'` (aka `0x4c`)
 - anchors: `size: (UInt16) TSVector3...`
 - fillmap: `UInt16[1024]`
 - fillAnchormap: `TSVector3[1024]`
 - datamap: `UInt8[1024]`
 
 */
private class _TSChunkSerialization {
    
    static let header = UInt8(0x4c)
    
    private func _writeVector(dos: ChunkDataWriteStream, _ vector3: inout TSVector3) throws {
        try dos.write(vector3.x16)
        try dos.write(vector3.y16)
        try dos.write(vector3.z16)
    }
    
    func data(from chunk: TSChunk) throws -> Data {
        let stream = ChunkDataWriteStream()
        
        try stream.write(_TSChunkSerialization.header)
        try stream.write(UInt16(chunk.anchors.count))
        
        for var anchor in chunk.anchors {
            try _writeVector(dos: stream, &anchor)
        }
        
        for i in 0..<1024 {
            
        }
    }
    
    func chunk(from data: Data) throws -> TSChunk {
        
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

    func int8() throws -> Int8 {
        return try self.readBytes()
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

    func int32() throws -> Int32 {
        let value:UInt32 = try self.readBytes()
        return Int32(bitPattern: CFSwapInt32BigToHost(value))
    }
    func uInt32() throws -> UInt32 {
        let value:UInt32 = try self.readBytes()
        return CFSwapInt32BigToHost(value)
    }

    func int64() throws -> Int64 {
        let value:UInt64 = try self.readBytes()
        return Int64(bitPattern: CFSwapInt64BigToHost(value))
    }
    func uInt64() throws -> UInt64 {
        let value:UInt64 = try self.readBytes()
        return CFSwapInt64BigToHost(value)
    }

    func float() throws -> Float {
        let value:CFSwappedFloat32 = try self.readBytes()
        return CFConvertFloatSwappedToHost(value)
    }

    func double() throws -> Double {
        let value:CFSwappedFloat64 = try self.readBytes()
        return CFConvertFloat64SwappedToHost(value)
    }

    func data(count: Int) throws -> Data {
        var buffer = [UInt8](repeating: 0, count: count)
        if self.inputStream.read(&buffer, maxLength: count) != count {
            
            throw ChunkDataStreamError.readError
        }
        offset += count
        return Data(buffer)
    }
    
    func string() throws -> String {
        let count = try uInt8()
        
        guard let string = String(bytes: try self.data(count: Int(count)), encoding: .utf8) else {
            throw ChunkDataStreamError.readError
        }
        
        return string
    }

    func bit() throws -> Bool {
        let byte = try self.uInt8() as UInt8
        return byte != 0
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

    func write(_ value: Int32) throws {
        try writeBytes(value: CFSwapInt32HostToBig(UInt32(bitPattern: value)))
    }
    func write(_ value: UInt32) throws {
        try writeBytes(value: CFSwapInt32HostToBig(value))
    }

    func write(_ value: Int64) throws {
        try writeBytes(value: CFSwapInt64HostToBig(UInt64(bitPattern: value)))
    }
    func write(_ value: UInt64) throws {
        try writeBytes(value: CFSwapInt64HostToBig(value))
    }
    
    func write(_ value: Float32) throws {
        try writeBytes(value: CFConvertFloatHostToSwapped(value))
    }
    func write(_ value: Float64) throws {
        try writeBytes(value: CFConvertFloat64HostToSwapped(value))
    }
    func write(_ data: Data) throws {
        var bytesWritten = 0
        
        withUnsafeBytes(of: data, {
            
            bytesWritten = outputStream.write($0.bindMemory(to: UInt8.self).baseAddress!, maxLength: data.count)
        })
        
        if bytesWritten != data.count {
            
            throw ChunkDataStreamError.writeError
        }
    }
    
    func write(_ string:String) throws {
        if string.isEmpty { return }
        guard let data = string.data(using: .utf8) else {return}
        
        try self.write(UInt8(data.count))
        try self.write(data)
    }
    
    func write(_ value: Bool) throws {
        try writeBytes(value: UInt8(value ? 0xff : 0x00))
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

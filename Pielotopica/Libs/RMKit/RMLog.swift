//
//  RMLog.swift
//  EXKit
//
//  Created by yuki on 2017/08/25.
//  Copyright © 2017 yuki. All rights reserved.
//

import Foundation

let log = RMLogger()

public struct RMLogger {
    
    private let handler:RMLogHandler
    private let constructor = RMLogConstructor()
    
    init(label:String = "main") {
        handler = RMLogHandler(label: label)
    }
}

extension RMLogger {
    public enum Level {
        case trace
        case debug
        case warning
        case error
    }
}

extension RMLogger {
    public func trace(
        _ message: Any,
        file: String = #file, function: String = #function, line: UInt = #line
    ) {
        #if DEBUG
        let _log = constructor.createPrintLog(level: .trace, message: message, file: file, function: function, line: line)
        
        print(_log)
        #endif
    }
    public func debug(
        _ message: Any,
        file: String = #file, function: String = #function, line: UInt = #line
    ) {
        #if DEBUG
        let _log = constructor.createPrintLog(level: .debug, message: message, file: file, function: function, line: line)
        
        print(_log)
        #endif
        let log = constructor.createLog(level: .debug, message: message, file: file, function: function, line: line)
        
        self.handler.log(level: .warning, message: log)
    }
    public func warn(
        _ message: Any,
        file: String = #file, function: String = #function, line: UInt = #line
    ) {
        #if DEBUG
        let _log = constructor.createPrintLog(level: .warning, message: message, file: file, function: function, line: line)
        
        print(_log)
        #endif
        let log = constructor.createLog(level: .warning, message: message, file: file, function: function, line: line)
        
        self.handler.log(level: .warning, message: log)
    }
    public func error(
        _ message: Any,
        file: String = #file, function: String = #function, line: UInt = #line
    ) {
        #if DEBUG
        let _log = constructor.createPrintLog(level: .error, message: message, file: file, function: function, line: line)
        
        print(_log)
        #endif
        let log = constructor.createLog(level: .error, message: message, file: file, function: function, line: line)
        
        self.handler.log(level: .error, message: log)
    }
}

private class RMLogConstructor {
    func createPrintLog(level: RMLogger.Level, message: Any, file: String, function: String, line: UInt) -> String {
        var logContent = [String]()
        logContent.append(_timestamp())
        logContent.append(_levelEmoji(for: level))
        logContent.append("\(message)")
        _fileTrace(level: level, file: file, function: function, line: line).map{logContent.append($0)}
        
        return logContent.joined(separator: " ")
    }
    
    func createLog(level: RMLogger.Level, message: Any, file: String, function: String, line: UInt) -> String {
        var logContent = [String]()
        logContent.append(_levelDesc(for: level))
        logContent.append(_timestamp())
        logContent.append("\(message)")
        _fileTrace(level: level, file: file, function: function, line: line).map{logContent.append($0)}
        logContent.append("\n")
        
        return logContent.joined(separator: " ")
    }
    
    private func _fileTrace(level: RMLogger.Level, file: String, function: String, line: UInt) -> String? {
        if level == .debug {return nil}
        
        return "file: \(file), func: \(function), line: \(line)"
    }
    
    private func _timestamp() -> String {
        var buffer = [Int8](repeating: 0, count: 255)
        var timestamp = time(nil)
        let localTime = localtime(&timestamp)
        strftime(&buffer, buffer.count, "%Y-%m-%d %H:%M:%S%z", localTime)
        
        return buffer.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: CChar.self) {
                String(cString: $0.baseAddress!)
            }
        }
    }
    private func _levelDesc(for level:RMLogger.Level) -> String {
      switch level {
        case .trace:   return "TRACE"
        case .debug:   return "DEBUG"
        case .warning: return "WARN"
        case .error:   return "ERROR"
        }
    }
    private func _levelEmoji(for level:RMLogger.Level) -> String {
        switch level {
        case .trace:   return "🏴🏴🏴"
        case .debug:   return "📘📘📘"
        case .warning: return "⚠️⚠️⚠️"
        case .error:   return "🚫🚫🚫"
        }
    }
}

private class RMLogHandler {
    private let label:String
    private let lock = NSLock()
    
    internal init(label:String) {
        self.label = label
    }
    
    internal func log(level: RMLogger.Level, message: String) {
        _writeMessage(message)
    }

    private func _logfilePath() -> String {
        #if os(macOS)
        guard let appSupportUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {fatalError()}
        guard let bundleID = Bundle.main.bundleIdentifier else {fatalError()}
        
        var saveUrl = appSupportUrl.appendingPathComponent(bundleID).appendingPathComponent("userdata")
        #endif
        
        #if os(iOS)
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {fatalError()}
        
        var saveUrl = documentUrl
        #endif
        
        saveUrl.appendPathComponent(label + ".log")
        
        return saveUrl.path
    }
    
    private func _writeMessage(_ message:String) {
        let clabel = _makeCString(from: _logfilePath())
        defer {clabel?.deallocate()}
        
        lock.lock()
        let file = fopen(clabel, "a")!
        
        defer {
            fclose(file)
            lock.unlock()
        }
        
        let cmessage = _makeCString(from: message)
        defer {cmessage?.deallocate()}
        
        vfprintf(file, cmessage, getVaList([]))
    }
    
    private func _makeCString(from string:String) -> UnsafePointer<Int8>? {
        guard let cstr = string.cString(using: .utf8) else {return nil}
        
        let pointer = UnsafeMutableBufferPointer<Int8>.allocate(capacity: cstr.count)
        _=pointer.initialize(from: cstr)
        
        return UnsafePointer(pointer.baseAddress!)
        
    }
}

//
//  RMDataStore.swift
//  Voiceroid
//
//  Created by yuki on 2019/02/01.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import BoxData

public typealias RMStorable = Codable

/**
 `RMStorable`を保存します。
 `RMStorage.Key`に型情報、IDを登録できるので、型安全に使える`UserDefault`のように使えます。
 全ての情報を先にメモリに読み込むことはありませんので、`UserDefault`より高速です。
 
 ----使い方---
 ```
 // Single Value
 extension RMStorage.Key{
    static var stringValueKey:RMStorage.Key<String> {return .init(rawValue: "_stringValueKey")}
 }
 
 let alice = "Alice"
 RMStorage.shared.store(alice, for: .stringValueKey)
 
 if let loadedAlice = RMStorage.shared.get(for: .stringValueKey){
    print(loadedAlice) // "Alice"
 }
 
 extension RMStorage.Key{
    static var personValueKey:RMStorage.Key<Person> {return .init(rawValue: "_personValueKey")}
 }
 
 // Struct Value
 struct Person:RMStorable {
    var id:Int
    var name:String
 }
 
 let bob = Person(id: 129, name: "Bob")
 RMStorage.shared.store(bob, for: .personValueKey)
 
 if let loadedBob = RMStorage.shared.get(for: .personValueKey){
    print(loadedBob.name) // "Bob"
 }
 ```
 */
public final class RMStorage {
    
    /// シングルトンです。
    public static let shared = RMStorage()
    
    private init() {}
    private let encoder = BoxEncoder()
    private let decoder = BoxDecoder()
    
    // ===========================================
    // ---- RMStorage Methods ----
    
    /// 引数`value`に与えられた値を保存します。
    /// に保存されます。
    public func store<T: RMStorable>(_ value:T, for key: RMStorage.Key<T>){
        let data = try! encoder.encode(value)
        guard let storePath = _storePath(for: key) else {return}
        
        FileManager.default.createFile(atPath: storePath, contents: data)
    }
    
    /// `Key`で指定した値を取り出します。
    /// 型キャストに失敗した場合、未保存の場合に`nil`を返します。
    public func get<T: RMStorable>(for key: RMStorage.Key<T>) -> T? {
        guard let storePath = _storePath(for: key) else {return nil}
        guard let data = FileManager.default.contents(atPath: storePath) else {return nil}
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    /// 指定した`Key`の実態を削除します。
    /// 削除した値を返り値として返します。
    @discardableResult
    public func remove<T: RMStorable>(with key:RMStorage.Key<T>) -> T? {
        guard let storePath = _storePath(for: key) else {return nil}
        guard let data = FileManager.default.contents(atPath: storePath) else {return nil}
        try? FileManager.default.removeItem(atPath: storePath)
        
        return try? decoder.decode(T.self, from: data)
    }
    
    /// ===========================================
    /// ---- RMStorage Private Methods ----
    
    /// `Key`をもとに実体を保存する場所を返します。
    /// macOSであれば
    /// `$HOME/Library/Application Support/(Bundle Name)/userdata/(Key Identifier).plist`です。
    /// iOSであれば
    /// `$APPROOT/Document/RMStrage/userdata/(Key Identifier).plist`
    private func _storePath<T: RMStorable>(for key:RMStorage.Key<T>) -> String?{
        guard let appSupportUrl = _fileSaveingUrl() else {return nil}
        if !FileManager.default.fileExists(atPath: appSupportUrl.absoluteString){
            try? FileManager.default.createDirectory(at: appSupportUrl, withIntermediateDirectories: true)
        }
        
        return appSupportUrl.appendingPathComponent(key.rawValue).appendingPathExtension("box").path
    }
    
    /// macOSであれば
    /// `$HOME/Library/Application Support/(Bundle Name)/userdata/`
    /// iOSであれば
    /// `$APPROOT/Document/RMStrage/userdata/`
    /// を返します。
    private func _fileSaveingUrl() -> URL?{
        #if os(macOS)
        guard let appSupportUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {return nil}
        guard let bundleID = Bundle.main.bundleIdentifier else {return nil}
        
        let saveUrl = appSupportUrl.appendingPathComponent(bundleID).appendingPathComponent("userdata")
        #endif
        
        #if os(iOS)
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        
        let saveUrl = documentUrl.appendingPathComponent("RMStorage").appendingPathComponent("userdata")
        #endif
        
        return saveUrl
    }
}

/// `struct Key`格調用
extension RMStorage {
    /// 保存する`Value`の`identifier`と型を登録します。
    public struct Key <Value: RMStorable> {
        fileprivate let rawValue:String
        
        public init(rawValue: String){
            self.rawValue = rawValue
        }
    }
}


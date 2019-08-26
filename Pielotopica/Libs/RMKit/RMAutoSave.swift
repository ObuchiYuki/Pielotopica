//
//  RMAutoSave.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/25.
//  Copyright © 2019 yuki. All rights reserved.
//

/**
 自動保存可能な値を表します。
 
 `static var shared = RMAutoSave<Triple>("__key__")`
 のように名前をつけるとその値で保存されます。
 
 keyの名前空間はRMStrageと共有なので、重複に注意してください。
 
 ## Usage
 
 ```
 struct Triple: RMAutoSavable {
    static var shared = RMAutoSave<Triple>("Triple__key__")
 
    var integer = 1
    var double = 3.14
    var string = "Hello"
 }
 
 
 Triple.shared.integer = 12
 Triple.shared.double = 2.71
 Triple.shared.string = "World"
 
 -- app end --
 -- app start --
 
 print(Triple.shared.integer) // 12
 print(Triple.shared.double) // 2.71
 print(Triple.shared.string) // "World"
 
 ```
 */
public protocol RMAutoSavable:RMStorable{init()};public class RMAutoSave<T:RMAutoSavable>{public var value:T{didSet{RMStorage.shared.store(value,for:_key)}};public func reset() {RMStorage.shared.remove(with: _key)};public init(_ key:String){value=RMStorage.shared.get(for:RMStorage.Key(rawValue: key)) ?? T();_key=RMStorage.Key(rawValue:key)};private let _key:RMStorage.Key<T>}

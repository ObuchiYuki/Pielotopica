//
//  _RMWeakObject.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/01.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

/// 弱参照のObjectをまとめて扱えます。
/// Objc由来のNSWeakCollectionと異なり方安全で使用できます。
public class RMWeakObjectSet<T> {

     
    private var _objects = NSHashTable<AnyObject>.weakObjects() // Set<_RMWeakObject<T>>

    internal var objects: [T] {
        
        return _objects.allObjects.compactMap{$0 as? T}
    }

    public init(_ objects: [T]) {
        for object in objects {
            _objects.add(object as AnyObject)
        }
    }

    public var all: [T] {
        return objects
    }

    public func contains(object: T) -> Bool {
        return _objects.contains(object as AnyObject)
    }

    public func append(_ object: T) {
        
        self._objects.add(object as AnyObject)
    }

    public func append(objects: [T]) {
        for object in objects {
            _objects.add(object as AnyObject)
        }
    }

    public func remove(_ object: T)  {
        _objects.remove(object as AnyObject)
    }
}

extension RMWeakObjectSet : Sequence {
    public typealias Iterator = _RMWeakObjectSetIterator
    
    public func makeIterator() -> Iterator {
        return _RMWeakObjectSetIterator(iterator: self.objects.makeIterator())
    }
    
    public struct _RMWeakObjectSetIterator: Sequence, IteratorProtocol {
        private var _iterator: Array<T>.Iterator
        
        fileprivate init(iterator: Array<T>.Iterator) {
            self._iterator = iterator
        }
        
        mutating public func next() -> T? {
            return _iterator.next()
        }
    }
}

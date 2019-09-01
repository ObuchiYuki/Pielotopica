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
public class RMWeakObjectSet<T: AnyObject> {

    private var _objects: Set<_RMWeakObject<T>>

    internal var objects: [T] {
        return _objects.compactMap{ $0.object }
    }

    public init() {
        self._objects = Set<_RMWeakObject<T>>([])
    }

    public init(_ objects: [T]) {
        self._objects = Set<_RMWeakObject<T>>(objects.map{ _RMWeakObject($0) })
    }

    public var all: [T] {
        return _objects.compactMap{ $0.object }
    }

    public func contains(object: T) -> Bool {
        return self._objects.contains(_RMWeakObject(object))
    }

    public func append(_ object: T) {
        self._objects.insert(_RMWeakObject(object))
    }

    public func append(objects: [T]) {
        self._objects.formUnion(objects.map{ _RMWeakObject($0) })
    }

    @discardableResult
    public func remove(_ object: T) -> T? {
        self._objects.remove(_RMWeakObject<T>(object))?.object
    }

}

extension RMWeakObjectSet : Sequence {
    public typealias Iterator = _RMWeakObjectSetIterator
    
    public func makeIterator() -> Iterator {
        return _RMWeakObjectSetIterator(iterator: self._objects.makeIterator())
    }
    
    public struct _RMWeakObjectSetIterator: Sequence, IteratorProtocol {
        private var _iterator: Set<_RMWeakObject<T>>.Iterator
        
        fileprivate init(iterator: Set<_RMWeakObject<T>>.Iterator) {
            self._iterator = iterator
        }
        
        mutating public func next() -> T? {
            return _iterator.next()?.object
        }
    }
}


private class _RMWeakObject<T: AnyObject> {

    weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension _RMWeakObject: Hashable {
    func hash(into hasher: inout Hasher) {
        guard let object = object else { return }
        hasher.combine(ObjectIdentifier(object))
    }
}
extension _RMWeakObject: Equatable {
    fileprivate static func == <T> (lhs: _RMWeakObject<T>, rhs: _RMWeakObject<T>) -> Bool {
        return lhs.object === rhs.object
    }
}

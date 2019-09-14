//
//  Extensions.swift
//  DANMAKER
//
//  Created by yuki on 2015/02/14.
//  Copyright © 2015 yuki. All rights reserved.
//

// MARK: - LibSwift Extensions

// MARK: - General Array Extensions
extension Array{
    
    /// Retrieve the element without causing an index error.
    /// If the index does not exist, nil is returned.
    ///
    /// - Parameter index: Index of the element to retrieve.
    /// - Returns: Elements retrieved
    public func at(_ index:Int) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Equatable && Hashable  Elements Array Extensions
extension Array where Element: Equatable & Hashable {
    
    /// Returns an array without duplication.
    @inline(__always)
    public var unique: [Element] {
        return Array(Set(self))
    }
    
    @inline(__always)
    public var uniqueWithOrder: [Element] {
        return reduce(into: [Element]()) {$0.contains($1) ? nil : $0.append($1)}
    }
    
    /// Remove a specific element from the array.
    ///
    /// - Parameter element: Element to removed
    /// - Returns: Removed element
    @inline(__always)
    @discardableResult
    public mutating func remove(of element:Element) -> Element?{
    if let index = firstIndex(of: element){
            return remove(at: index)
        }
        
        return nil
    }
    
    @inline(__always)
    @discardableResult
    public mutating func removeFirst(_ condition: (Element)->Bool) -> Element? {
        for element in self {
            if condition(element) {
                return self.remove(of: element)
            }
        }
    }
}


// MARK: - String Extensions
extension String{
    
    /// Returns a string from which a specific character string has been removed.
    ///
    /// - Parameter item: String to delete.
    /// - Returns: String with specific String removed.
    public func removed(_ chars:String)->String{
        return self.replacingOccurrences(of: chars, with: "")
    }
}

extension Comparable {
    func into(_ range: ClosedRange<Self>) -> Self {
        return max(range.lowerBound, min(self, range.upperBound))
    }
}



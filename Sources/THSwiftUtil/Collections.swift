//
//  Collections.swift
//  THSwiftUtil
//
//  Created by Thomas Hamming on 7/25/2020
//

import Foundation

/// A group of elements with a key
public struct Group<Key, Element> {
    public let key: Key
    private var elements: [Element]
    init(_ key: Key) {
        self.key = key
        self.elements = []
    }
    
    fileprivate mutating func append(_ newElement: Element) {
        self.elements.append(newElement)
    }
}

extension Group : Sequence {
    public func makeIterator() -> IndexingIterator<Array<Element>> {
        return self.elements.makeIterator()
    }
}

extension Group : Collection {
    public var startIndex: Int {
        return self.elements.startIndex
    }
    
    public var endIndex: Int {
        return self.elements.endIndex
    }
    
    public func index(after i: Int) -> Int {
        return self.elements.index(after: i)
    }
    
    public subscript(position: Int) -> Element {
        return self.elements[position]
    }
}

public extension Collection where Element : Hashable {
    
    /// Distinct elements in the sequence
    /// - Returns: An array of distinct values
    func distinct() -> [Element] {
        guard self.count > 0 else { return [] }
        
        var set = Set<Element>()
        var result: [Element] = []
        for elem in self {
            if set.insert(elem).inserted {
                result.append(elem)
            }
        }
        
        return result
    }
    
    /// Number of distinct values in the sequence
    /// - Returns: Number of distinct values in the sequence
    func countDistinct() -> Int {
        guard self.count > 0 else { return 0 }
        
        var set = Set<Element>()
        for elem in self {
            _ = set.insert(elem)
        }
        
        return set.count
    }
}

public extension Collection {
    
    /// Group elements of a collection by a value produced by a transform
    /// - Parameter transform: Transform each element to its key value
    /// - Throws: Any error thrown by the transform
    /// - Returns: An array of groups of elements, where each group's key is a value produced by the transform and the elements are the elements of the collection that transformed to that value
    func groupBy<T: Hashable>(_ transform: (Self.Element) throws -> T) rethrows -> [Group<T, Self.Element>] {
        var groups: [T: Group<T, Self.Element>] = [:]
        for element in self {
            let key = try transform(element)
            if groups[key] == nil {
                groups[key] = Group(key)
            }
            
            groups[key]?.append(element)
        }
        
        return Array(groups.values)
    }
    
    /// Count the elements in the collection satisfying a given condition
    /// - Parameter transform: The condition to satisfy
    /// - Throws: Any error thrown by the transform
    /// - Returns: Count of elements that satisfy the condition
    func countWhere(_ transform: (Self.Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self {
            if try transform(element) {
                count += 1
            }
        }
        
        return count
    }
    
    /// Get the distinct values from a collection, transforming the elements
    /// - Parameter transform: Transform each element to a Hashable
    /// - Throws: Any error thrown by the transform
    /// - Returns: An array of distinct values produced by the transform
    func distinct<T: Hashable>(_ transform: (Self.Element) throws -> T) rethrows -> [T] {
        guard self.count > 0 else { return [] }
        
        var set = Set<T>()
        var result: [T] = []
        for elem in self {
            let val = try transform(elem)
            if set.insert(val).inserted {
                result.append(val)
            }
        }
        
        return result
    }
    
    /// Get the number of distinct values, transforming the elements
    /// - Parameter transform: Transform each element to a Hashable
    /// - Throws: Any error thrown by the transform
    /// - Returns: The count of distinct values produced by the transform
    func countDistinct<T: Hashable>(_ transform: (Self.Element) throws -> T) rethrows -> Int {
        guard self.count > 0 else { return 0 }
        
        var set = Set<T>()
        for elem in self {
            _ = set.insert(try transform(elem))
        }
        
        return set.count
    }
}

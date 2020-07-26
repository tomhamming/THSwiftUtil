//
//  Collections.swift
//  THSwiftUtil
//
//  Created by Thomas Hamming on 7/25/2020
//  Copyright © 2020 Thomas Hamming. All rights reserved.
//

import Foundation

/// A group of elements with a key
struct Group<Key, Element> {
    let key: Key
    private var elements: [Element]
    init(_ key: Key) {
        self.key = key
        self.elements = []
    }
    
    mutating func append(_ newElement: Element) {
        self.elements.append(newElement)
    }
}

extension Group : Sequence {
    typealias Iterator = IndexingIterator<Array<Element>>
    
    func makeIterator() -> Iterator {
        return self.elements.makeIterator()
    }
}

extension Group : Collection {
    var startIndex: Int {
        return self.elements.startIndex
    }
    
    var endIndex: Int {
        return self.elements.endIndex
    }
    
    func index(after i: Int) -> Int {
        return self.elements.index(after: i)
    }
    
    subscript(position: Int) -> Element {
        return self.elements[position]
    }
}

extension Collection where Element : Numeric {
    
    /// Sum elements of a sequence of numerics
    /// - Returns: The sum of the elements of the sequence
    func sum() -> Element {
        return reduce(0, +)
    }
}

extension Collection where Element : Comparable {
    
    /// Find the maximum element in the collection
    /// - Returns: Max element
    func max() -> Element? {
        var best: Element? = nil
        for e in self {
            if best == nil || e > best! {
                best = e
            }
        }
        
        return best
    }
    
    /// Find the minimum element in the collection
    /// - Returns: Min element
    func min() -> Element? {
        var best: Element? = nil
        for e in self {
            if best == nil || e < best! {
                best = e
            }
        }
        
        return best
    }
}

extension Collection where Element : Hashable {
    
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

extension Collection {
    
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
    
    
    /// Sum the elements of a collection transformed to a numeric
    /// - Parameter transform: Transform each element to a numeric
    /// - Throws: Any error thrown by the transform
    /// - Returns: Sum of the elements
    func sum<T: Numeric>(_ transform: (Self.Element) throws -> T) rethrows -> T {
        var total: T = 0
        for e in self {
            total += try transform(e)
        }
        
        return total
    }
    
    
    /// Sort elements ascending by the result of a transform
    /// - Parameter transform: Transform each element to its comparable value
    /// - Throws: Any error thrown by the transform
    /// - Returns: A sorted array
    func sortedBy<T: Comparable>(_ transform: (Self.Element) throws -> T) rethrows -> [Self.Element] {
        return try self.sorted { (lhs, rhs) -> Bool in
            let l = try transform(lhs)
            let r = try transform(rhs)
            return l < r
        }
    }
    
    /// Sort elements descending by the result of a transform
    /// - Parameter transform: Transform each element to its comparable value
    /// - Throws: Any error thrown by the transform
    /// - Returns: A sorted (descending) array
    func sortedByDescending<T: Comparable>(_ transform: (Self.Element) throws -> T) rethrows -> [Self.Element] {
        return try self.sorted { (lhs, rhs) -> Bool in
            let l = try transform(lhs)
            let r = try transform(rhs)
            return r < l
        }
    }
    
    /// Find the minimum element in the collection according to a given transform
    /// - Parameter transform: Transform each element to a comparable value
    /// - Throws: Any error thrown by the transform
    /// - Returns: The minimum element, or nil if the collection is empty
    func min<T: Comparable>(_ transform: (Self.Element) throws -> T) rethrows -> Self.Element? {
        var best: (elem: Self.Element, val: T)? = nil
        for elem in self {
            let val = try transform(elem)
            if best == nil || val < best!.val {
                best = (elem, val)
            }
        }
        
        return best?.elem
    }
    
    /// Find the maximum element in the collection according to a given transform
    /// - Parameter transform: Transform each element to a comparable value
    /// - Throws: Any error thrown by the transform
    /// - Returns: The maximum elmeent, or nil if the collection is empty
    func max<T: Comparable>(_ transform: (Self.Element) throws -> T) rethrows -> Self.Element? {
        var best: (elem: Self.Element, val: T)? = nil
        for elem in self {
            let val = try transform(elem)
            if best == nil || val > best!.val {
                best = (elem, val)
            }
        }
        
        return best?.elem
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

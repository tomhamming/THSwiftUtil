//
//  Sequences.swift
//  THSwiftUtil
//
//  Created by Thomas Hamming on 7/25/20.
//

import Foundation

extension Sequence where Element : Numeric {
    
    /// Sum elements of a sequence of numerics
    /// - Returns: The sum of the elements of the sequence
    func sum() -> Element {
        return reduce(0, +)
    }
}

extension Sequence {
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
}

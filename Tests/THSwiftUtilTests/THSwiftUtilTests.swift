import XCTest
@testable import THSwiftUtil

fileprivate struct TestInt : Equatable {
    let val: Int
    init(_ i: Int) {
        self.val = i
    }
}

fileprivate extension Collection where Element == Int {
    func asInts() -> [TestInt] {
        return self.map({TestInt($0)})
    }
}

final class THSwiftUtilTests: XCTestCase {
    
    // MARK: - Sum tests
    func testSum() throws {
        var ints = [1, 2, 3]
        XCTAssert(ints.sum() == 6)
        
        ints = [0]
        XCTAssert(ints.sum() == 0)
        
        ints = [-1, 5, -4]
        XCTAssert(ints.sum() == 0)
        
        ints = []
        XCTAssert(ints.sum() == 0)
        
        var doubles = [1.5, 2.5]
        XCTAssert(doubles.sum() == 4)
        
        doubles = [1.5, 2.5, -4]
        XCTAssert(doubles.sum() == 0)
    }
    
    func testSumTransform() throws {
        var values = [1, 2, 3].asInts()
        XCTAssert(values.sum({$0.val}) == 6)
        
        values = []
        XCTAssert(values.sum({$0.val}) == 0)
    }
    
    //MARK: - Distinct tests
    
    func testDistinct() throws {
        var ints = [1, 1, 2]
        XCTAssert(ints.distinct().count == 2)
        XCTAssert(ints.distinct().contains(1))
        XCTAssert(ints.distinct().contains(2))
        
        ints = [1, 2, 3]
        XCTAssert(ints.distinct() == ints)
        
        ints = [-1]
        XCTAssert(ints.distinct().count == 1)
        XCTAssert(ints.distinct().first == -1)
        
        ints = []
        XCTAssert(ints.distinct().count == 0)
        
        ints = [1, 1, 1]
        XCTAssert(ints.distinct().count == 1)
        XCTAssert(ints.distinct().first == 1)
    }
    
    func testDistinctTransform() throws {
        var ints = [1, 2, 2].asInts()
        XCTAssert(ints.distinct({$0.val}).count == 2)
        
        ints = [42].asInts()
        XCTAssert(ints.distinct({$0.val}).count == 1)
        
        ints = []
        XCTAssert(ints.distinct({$0.val}).count == 0)
    }
    
    func testCountDistinct() throws {
        var ints = [1, 2, 3]
        XCTAssert(ints.countDistinct() == 3)
        
        ints = [1, 1, 2]
        XCTAssert(ints.countDistinct() == 2)
        
        ints = [1, 1]
        XCTAssert(ints.countDistinct() == 1)
        
        ints = [1]
        XCTAssert(ints.countDistinct() == 1)
        
        ints = []
        XCTAssert(ints.countDistinct() == 0)
    }
    
    func testCountDistinctTransform() throws {
        var ints = [1, 2, 3].asInts()
        XCTAssert(ints.countDistinct({$0.val}) == 3)
        
        ints = [1, 1, 2].asInts()
        XCTAssert(ints.countDistinct({$0.val}) == 2)
        
        ints = [1, 1].asInts()
        XCTAssert(ints.countDistinct({$0.val}) == 1)
        
        ints = [1].asInts()
        XCTAssert(ints.countDistinct({$0.val}) == 1)
        
        ints = []
        XCTAssert(ints.countDistinct({$0.val}) == 0)
    }
    
    // MARK: - Min tests
    func testMin() throws {
        var ints = [1, 2, 3].asInts()
        XCTAssert(ints.min({$0.val})?.val == 1)
        
        ints = [3, 2, 1].asInts()
        XCTAssert(ints.min({$0.val})?.val == 1)
        
        ints = [1, -1000, 400].asInts()
        XCTAssert(ints.min({$0.val})?.val == -1000)
        
        ints = []
        XCTAssert(ints.min({$0.val}) == nil)
    }
    
    //MARK: - Max tests
    func testMax() throws {
        var ints = [1, 2, 3].asInts()
        XCTAssert(ints.max({$0.val})?.val == 3)
        
        ints = [3, 2, 1].asInts()
        XCTAssert(ints.max({$0.val})?.val == 3)
        
        ints = [1, -1000, 400].asInts()
        XCTAssert(ints.max({$0.val})?.val == 400)
        
        ints = []
        XCTAssert(ints.max({$0.val}) == nil)
    }
    
    //MARK: - Group tests
    func testGroup() throws {
        var values = [0, 5, 10, 11, 13].asInts()
        var groups = values.groupBy({$0.val % 2 == 0}).sortedBy({$0.count})
        
        XCTAssertEqual(groups.count, 2)
        
        XCTAssertEqual(groups[0].count, 2)
        XCTAssertEqual(groups[1].count, 3)
        
        values = []
        groups = values.groupBy({$0.val % 2 == 0})
        XCTAssertEqual(groups.count, 0)
    }
    
    //MARK: - Sort tests
    
    func testSortBy() throws {
        var values = [1, 2, 4, 2, 5, -1].asInts()
        var sorted = values.sortedBy({$0.val})
        XCTAssertEqual(sorted, [-1, 1, 2, 2, 4, 5].asInts())
        
        sorted = values.sortedByDescending({$0.val})
        XCTAssertEqual(sorted, [5, 4, 2, 2, 1, -1].asInts())
        
        values = []
        sorted = values.sortedBy({$0.val})
        XCTAssertEqual(sorted.count, 0)
        
        sorted = values.sortedByDescending({$0.val})
        XCTAssertEqual(sorted.count, 0)
    }
    
    //MARK: CountWhere tests
    
    func testCountWhere() throws {
        var ints = [1, 2, 3, 4]
        XCTAssertEqual(ints.countWhere({$0 % 2 == 0}), 2)
        
        ints = [1, 2]
        XCTAssertEqual(ints.countWhere({$0 % 2 == 0}), 1)
        
        ints = [1, 3, 5]
        XCTAssertEqual(ints.countWhere({$0 % 2 == 0}), 0)
        
        ints = []
        XCTAssertEqual(ints.countWhere({$0 % 2 == 0}), 0)
    }
}

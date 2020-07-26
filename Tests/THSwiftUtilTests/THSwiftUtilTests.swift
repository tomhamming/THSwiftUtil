import XCTest
@testable import THSwiftUtil

final class THSwiftUtilTests: XCTestCase {
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
    
    fileprivate struct TestInt {
        let val: Int
        init(_ i: Int) {
            self.val = i
        }
    }
    func testSumTransform() throws {
        var values = [TestInt(1), TestInt(2), TestInt(3)]
        XCTAssert(values.sum({$0.val}) == 6)
        
        values = []
        XCTAssert(values.sum({$0.val}) == 0)
    }
    
    func testMin() throws {
        var ints = [1, 2, 3]
        XCTAssert(ints.min() == 1)
        
        ints = [3, 2, 1]
        XCTAssert(ints.min() == 1)
        
        ints = [1, -1000, 400]
        XCTAssert(ints.min() == -1000)
        
        ints = []
        XCTAssert(ints.min() == nil)
        
        var strings = ["Hello", "World", "AA"]
        XCTAssert(strings.min() == "AA")
        
        strings = ["Hello", "AA", "aa"]
        XCTAssert(strings.min() == "AA")
    }

    func testGroup() throws {
        let values = [TestInt(0), TestInt(5), TestInt(10), TestInt(11), TestInt(13)]
        let groups = values.groupBy({$0.val % 2 == 0})
        
        XCTAssertEqual(groups.count, 2)
        
        let trueIndex = (groups[0].key ? 0 : 1)
        let falseIndex = (trueIndex == 1 ? 0 : 1)
        
        XCTAssertEqual(groups[trueIndex].count, 2)
        XCTAssertEqual(groups[falseIndex].count, 3)
    }
}

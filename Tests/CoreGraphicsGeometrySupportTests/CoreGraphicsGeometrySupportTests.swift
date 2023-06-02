@testable import CoreGraphicsGeometrySupport
import XCTest

final class CoreGraphicsGeometrySupportTests: XCTestCase {
    func testCGAffineTransformSimpleDecompose() {
        let t2 = CGAffineTransform(scaleX: 10, y: 20)
        XCTAssertEqual(t2.scale.x, 10)
        XCTAssertEqual(t2.scale.y, 20)
    }


    func testCGAffineTransformComplexDecompose() {
        let t1 = CGAffineTransform(rotation: 0.7853982)
        XCTAssertEqual(t1.rotation, 0.7853982, accuracy: 0.0001)
        let t2 = t1.scaledBy(x: 10, y: 20)
        let s = t2.scale
        XCTAssertEqual(s.x, 10)
        XCTAssertEqual(s.y, 20)
    }
}

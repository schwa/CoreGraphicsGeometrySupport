import CoreGraphics

// MARK: Label-less inits

public extension CGPoint {
    init(_ x: CGFloat, _ y: CGFloat) {
        self.init(x: x, y: y)
    }
}

public extension CGSize {
    init(_ width: CGFloat, _ height: CGFloat) {
        self.init(width: width, height: height)
    }
}

// MARK: To/From Arrays

public extension CGPoint {
    init(_ scalars: [CGFloat]) {
        assert(scalars.count == 2)
        self.init(x: scalars[0], y: scalars[1])
    }

    var scalars: [CGFloat] {
        // TODO: Provide a setter
        return [x, y]
    }
}

public extension CGSize {
    init(_ scalars: [CGFloat]) {
        assert(scalars.count == 2)
        self.init(width: scalars[0], height: scalars[1])
    }

    var scalars: [CGFloat] {
        // TODO: Provide a setter
        return [width, height]
    }
}

// MARK: ExpressibleByArrayLiteral

extension CGPoint: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CGFloat...) {
        self.init(elements)
    }
}

extension CGSize: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CGFloat...) {
        self.init(elements)
    }
}

// MARK: Map

public extension CGPoint {
    func map(_ block: (CGFloat) throws -> CGFloat) rethrows -> Self {
        return Self(try block(x), try block(y))
    }
}

public extension CGSize {
    func map(_ block: (CGFloat) throws -> CGFloat) rethrows -> Self {
        return Self(try block(width), try block(height))
    }
}

// MARK: To/From Tuples

public extension CGPoint {
    init(tuple: (CGFloat, CGFloat)) {
        self.init(x: tuple.0, y: tuple.1)
    }

    var tuple: (CGFloat, CGFloat) {
        (x, y)
        // TODO: Provide a setter
    }
}

public extension CGSize {
    init(tuple: (CGFloat, CGFloat)) {
        self.init(width: tuple.0, height: tuple.1)
    }

    var tuple: (CGFloat, CGFloat) {
        (width, height)
        // TODO: Provide a setter
    }
}

// MARK: Hashable

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        x.hash(into: &hasher)
        y.hash(into: &hasher)
    }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        width.hash(into: &hasher)
        height.hash(into: &hasher)
    }
}

// MARK: Math with Self types

public extension CGPoint {

    static prefix func - (rhs: Self) -> Self {
        return Self(-rhs.x, -rhs.y)
    }

    static func + (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x + rhs.x, lhs.y + rhs.y)
    }

    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    static func - (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x - rhs.x, lhs.y - rhs.y)
    }

    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }

    static func * (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x * rhs.x, lhs.y * rhs.y)
    }

    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }

    static func / (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x / rhs.x, lhs.y / rhs.y)
    }

    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
}

public extension CGSize {

    static prefix func - (rhs: Self) -> Self {
        return Self(-rhs.width, -rhs.width)
    }

    static func + (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.width + rhs.width, lhs.height + rhs.height)
    }

    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    static func - (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.width - rhs.width, lhs.height - rhs.height)
    }

    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }

    static func * (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.width * rhs.width, lhs.height * rhs.height)
    }

    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }

    static func / (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.width / rhs.width, lhs.height / rhs.height)
    }

    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
}

// MARK: Math with Scalars

public extension CGPoint {

    static func * (lhs: Self, rhs: CGFloat) -> Self {
        return Self(lhs.x * rhs, lhs.y * rhs)
    }

    static func *= (lhs: inout Self, rhs: CGFloat) {
        lhs = lhs * rhs
    }

    static func / (lhs: Self, rhs: CGFloat) -> Self {
        return Self(lhs.x / rhs, lhs.y / rhs)
    }

    static func /= (lhs: inout Self, rhs: CGFloat) {
        lhs = lhs / rhs
    }

    static func * (lhs: CGFloat, rhs: Self) -> Self {
        return Self(lhs * rhs.x, lhs * rhs.y)
    }
}

public extension CGSize {

    static func * (lhs: Self, rhs: CGFloat) -> Self {
        return Self(lhs.width * rhs, lhs.height * rhs)
    }

    static func *= (lhs: inout Self, rhs: CGFloat) {
        lhs = lhs * rhs
    }

    static func / (lhs: Self, rhs: CGFloat) -> Self {
        return Self(lhs.width / rhs, lhs.height / rhs)
    }

    static func /= (lhs: inout Self, rhs: CGFloat) {
        lhs = lhs / rhs
    }

}


// MARK: Conversion

public extension CGPoint {
    init(_ size: CGSize) {
        self = Self(size.width, size.height)
    }
}

public extension CGSize {
    init(_ point: CGPoint) {
        self = Self(point.x, point.y)
    }
}

// MARK: Random

public extension CGPoint {

    static func random <T>(x: ClosedRange<CGFloat>, y: ClosedRange<CGFloat>, using generator: inout T) -> Self where T: RandomNumberGenerator {
        return Self(x: CGFloat.random(in: x, using: &generator), y: CGFloat.random(in: y, using: &generator))
    }

    static func random(x: ClosedRange<CGFloat>, y: ClosedRange<CGFloat>) -> Self {
        var rng = SystemRandomNumberGenerator()
        return random(x: x, y: y, using: &rng)
    }

    static func random<T>(using generator: inout T) -> Self where T: RandomNumberGenerator {
        return Self.random(x: 0...1, y: 0...1, using: &generator)
    }

    static func random() -> Self {
        var rng = SystemRandomNumberGenerator()
        return Self.random(using: &rng)
    }

    static func random<T>(in rect: CGRect, using generator: inout T) -> Self where T: RandomNumberGenerator {
        return Self.random(x: rect.minX ... rect.maxX, y: rect.minY ... rect.maxY, using: &generator)
    }

    static func random(in rect: CGRect) -> Self {
        var rng = SystemRandomNumberGenerator()
        return Self.random(in: rect, using: &rng)
    }

}

public extension CGSize {
    static func random <T>(width: ClosedRange<CGFloat>, height: ClosedRange<CGFloat>, using generator: inout T) -> Self where T: RandomNumberGenerator {
        return Self(width: CGFloat.random(in: width, using: &generator), height: CGFloat.random(in: height, using: &generator))
    }

    static func random(width: ClosedRange<CGFloat>, height: ClosedRange<CGFloat>) -> Self {
        var rng = SystemRandomNumberGenerator()
        return random(width: width, height: height, using: &rng)
    }

    // TODO: It doesn't really make any sense to have other RNG methods on CGSize?
}

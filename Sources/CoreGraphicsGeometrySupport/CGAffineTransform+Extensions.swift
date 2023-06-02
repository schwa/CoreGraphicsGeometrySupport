import CoreGraphics

// MARK: Printable

extension CGAffineTransform: CustomStringConvertible {
    public var description: String {
        "CGAffineTransform(\(a), \(b), \(c), \(d), \(tx), \(ty))"
    }
}

// MARK: Constructors

public extension CGAffineTransform {
    init() {
        self = CGAffineTransform.identity
    }

    init(translation: CGPoint) {
        self = CGAffineTransform(translationX: translation.x, y: translation.y)
    }

    init(tx: CGFloat, ty: CGFloat) {
        self = CGAffineTransform(translationX: tx, y: ty)
    }

    init(scale: CGSize) {
        self = CGAffineTransform(scaleX: scale.width, y: scale.height)
    }

    init(sx: CGFloat, sy: CGFloat) {
        self = CGAffineTransform(scaleX: sx, y: sy)
    }

    init(scale: CGFloat) {
        self = CGAffineTransform(scaleX: scale, y: scale)
    }

    init(scale: CGFloat, origin: CGPoint) {
        self = CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: (1 - scale) * origin.x, ty: (1 - scale) * origin.y)
    }

    init(rotation: CGFloat) {
        self = CGAffineTransform(rotationAngle: rotation)
    }

    init(rotation: CGFloat, origin: CGPoint) {
        self = CGAffineTransform(translation: -origin) + CGAffineTransform(rotation: rotation) + CGAffineTransform(translation: origin)
    }
}

// MARK: -

public extension CGAffineTransform {
    // TODO: Most of these should be removed and the normal CGAffineTransform code relied on

    func translated(_ translation: CGPoint) -> CGAffineTransform {
        translatedBy(x: translation.x, y: translation.y)
    }

    func translated(tx: CGFloat, ty: CGFloat) -> CGAffineTransform {
        translatedBy(x: tx, y: ty)
    }

    func scaled(_ scale: CGSize) -> CGAffineTransform {
        scaledBy(x: scale.width, y: scale.height)
    }

    func scaled(sx: CGFloat, sy: CGFloat) -> CGAffineTransform {
        scaledBy(x: sx, y: sy)
    }

    func scaled(_ scale: CGFloat) -> CGAffineTransform {
        scaledBy(x: scale, y: scale)
    }

    func scaled(_ scale: CGFloat, origin: CGPoint) -> CGAffineTransform {
        self + CGAffineTransform(scale: scale, origin: origin)
    }

    func rotated(_ angle: CGFloat) -> CGAffineTransform {
        rotated(by: angle)
    }

    func rotated(_ rotation: CGFloat, origin: CGPoint) -> CGAffineTransform {
        CGAffineTransform(rotation: rotation, origin: origin)
    }
}

public extension CGAffineTransform {
    mutating func translate(translation: CGPoint) -> CGAffineTransform {
        self = translated(tx: translation.x, ty: translation.y)
        return self
    }

    mutating func translate(tx: CGFloat, _ ty: CGFloat) -> CGAffineTransform {
        self = translated(tx: tx, ty: ty)
        return self
    }

    mutating func scale(scale: CGSize) -> CGAffineTransform {
        self = scaled(sx: scale.width, sy: scale.height)
        return self
    }

    mutating func scale(sx: CGFloat, _ sy: CGFloat) -> CGAffineTransform {
        self = scaled(sx: sx, sy: sy)
        return self
    }

    mutating func scale(scale: CGFloat) -> CGAffineTransform {
        self = scaled(sx: scale, sy: scale)
        return self
    }

    mutating func scale(scale: CGFloat, origin: CGPoint) -> CGAffineTransform {
        self = scaled(scale, origin: origin)
        return self
    }

    mutating func rotate(angle: CGFloat) -> CGAffineTransform {
        self = rotated(angle)
        return self
    }

    mutating func rotate(angle: CGFloat, origin: CGPoint) -> CGAffineTransform {
        self = rotated(angle, origin: origin)
        return self
    }

    mutating func concat(other: CGAffineTransform) -> CGAffineTransform {
        self = concatenating(other)
        return self
    }

    mutating func invert() -> CGAffineTransform {
        self = inverted()
        return self
    }
}

// MARK: Concatination via the + and += operators

public extension CGAffineTransform {
    static func + (lhs: CGAffineTransform, rhs: CGAffineTransform) -> CGAffineTransform {
        lhs.concatenating(rhs)
    }

    static func += (lhs: inout CGAffineTransform, rhs: CGAffineTransform) {
        lhs = lhs.concat(other: rhs)
    }
}

// MARK: Transform a vector

public extension CGAffineTransform {
    func transform(point: CGPoint) -> CGPoint {
        return CGPointApplyAffineTransform(point, self)
    }
}

// MARK: Converting transforms to/from arrays

public extension CGAffineTransform {
    init(v: [CGFloat]) {
        assert(v.count == 6)
        self = CGAffineTransform(a: v[0], b: v[1], c: v[2], d: v[3], tx: v[4], ty: v[5])
    }

    var values: [CGFloat] {
        get {
            [a, b, c, d, tx, ty]
        }
        set(v) {
            assert(v.count == 6)
            (a, b, c, d, tx, ty) = (v[0], v[1], v[2], v[3], v[4], v[6])
        }
    }
}

// MARK: Convenience constructors.

public extension CGAffineTransform {
    init(transforms: [CGAffineTransform]) {
        var current = CGAffineTransform.identity
        for transform in transforms {
            current = current.concat(other: transform)
        }
        self = current
    }

//    // Constructor with two fingers' positions while moving fingers.
//    init(from1: CGPoint, from2: CGPoint, to1: CGPoint, to2: CGPoint) {
//        if from1 == from2 || to1 == to2 {
//            self = CGAffineTransform.identity
//        }
//        else {
//            let scale = to2.distance(to: to1) / from2.distance(to: from1)
//            let angle1 = (to2 - to1).angle, angle2 = (from2 - from1).angle
//            self = CGAffineTransform(translation: to1 - from1)
//                + CGAffineTransform(scale: scale, origin: to1)
//                + CGAffineTransform(rotation: angle1 - angle2, origin: to1)
//        }
//    }
}

// MARK: Decompose

public extension CGAffineTransform {

    /*                      |------------------ CGAffineTransformComponents ----------------|
     *
     *      | a  b  0 |     | sx  0  0 |   |  1  0  0 |   | cos(t)  sin(t)  0 |   | 1  0  0 |
     *      | c  d  0 |  =  |  0 sy  0 | * | sh  1  0 | * |-sin(t)  cos(t)  0 | * | 0  1  0 |
     *      | tx ty 1 |     |  0  0  1 |   |  0  0  1 |   |   0       0     1 |   | tx ty 1 |
     *  CGAffineTransform      scale           shear            rotation          translation
     */

    /*
     | a11 a12 0 |    | a11 a21 0 |
     | a21 a22 0 | vs | a12 a22 0 |
     | tx  ty  0 |    | tx  ty  0 |
     */

    var decompose: (translation: CGPoint, scale: CGPoint, rotation: CGFloat, shear: CGFloat) {
        // https://math.stackexchange.com/questions/612006/decomposing-an-affine-transformation
        let a11 = a
        let a12 = c
        let a21 = b
        let a22 = d

        let sx = sqrt(a11 * a11 + a21 * a21)
        let 𝜃 = atan(a21 / a11)
        let msy = a12 * cos(𝜃) + a22 * sin(𝜃)
        let sy: Double
        if sin(𝜃) != 0 {
            sy = (msy * cos(𝜃) - a12) / sin(𝜃)
        }
        else {
            sy = (a22 - msy * sin(𝜃)) / cos(𝜃)
        }
        let m = msy / sy

        return (translation, CGPoint(sx, sy), 𝜃, m)
    }


    var translation: CGPoint {
        return CGPoint(x: tx, y: ty)
    }

    var rotation: CGFloat {
        return decompose.rotation
    }

    var scale: CGPoint {
        return decompose.scale
    }

    var shear: CGFloat {
        return decompose.shear
    }
}


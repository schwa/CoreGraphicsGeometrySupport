import CoreGraphics

public func lerp(from: CGPoint, to: CGPoint, by t: CGFloat) -> CGPoint {
    return ((1.0 - t) * from) + (t * to)
}

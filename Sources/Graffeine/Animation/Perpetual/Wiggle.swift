import UIKit

extension GraffeineAnimation.Perpetual {

    public static func Wiggle(duration: TimeInterval = 0.12) -> CAAnimation {
        let oneDeg = CGFloat(Double.pi / 180)
        let left  = 0 - oneDeg
        let right = 0 + oneDeg

        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = duration
        animation.fromValue = left
        animation.toValue   = right
        animation.autoreverses = true
        animation.repeatCount = .infinity
        return animation
    }
}

//
//  Created by Alessio Orlando on 07/10/15.
//  Copyright © 2015 Alessio Orlando. All rights reserved.
//

import Foundation
import UIKit

enum ArrowDirection {
    case up
    case down
    case left
    case right
}


/// Generates images similar to table view cell disclosure indicator.
/// Allows customization of direction, size, color and so on.
class ArrowImageGenerator {

    static var defaultColor: UIColor = {
        let color = UIColor(red: 0.783922, green: 0.780392, blue: 0.8, alpha: 1)
        return color
    }()

    class func generateArrow(withDirection direction: ArrowDirection = .right,
                             size: CGSize? = nil,
                             lineWidth: CGFloat = 2.0,
                             arrowColor: UIColor = ArrowImageGenerator.defaultColor,
                             backgroundColor: UIColor = .clear,
                             scale: CGFloat = UIScreen.main.scale)
        -> UIImage? {

            var actualSize: CGSize
            if let size = size {
                actualSize = size
            } else {
                actualSize = defaultSize(for: direction)
            }

            let scaledSize = actualSize.applying(CGAffineTransform(scaleX: scale, y: scale))
            let scaledLineWidth = lineWidth * scale

            UIGraphicsBeginImageContext(CGSize(width: scaledSize.width, height: scaledSize.height))
            defer {
                UIGraphicsEndImageContext()
            }

            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            configureForArrowDrawing(context)

            UIGraphicsPushContext(context)
            strokeArrow(context, size: scaledSize, arrowColor: arrowColor, backgroundColor: backgroundColor, lineWidth: scaledLineWidth, direction: direction)
            UIGraphicsPopContext()

            guard let outputImage = UIGraphicsGetImageFromCurrentImageContext(),
                let quartzImage = context.makeImage() else {
                return nil
            }

            let scaledImage = UIImage(cgImage: quartzImage, scale: scale, orientation: outputImage.imageOrientation)
            return scaledImage
    }

    private class func generateResizableArrow(_ arrowImage: UIImage, direction: ArrowDirection) -> UIImage {
        var edgeInset: UIEdgeInsets?
        switch direction {
        case .up:
            edgeInset = UIEdgeInsets(top: 11, left: 0, bottom: 1, right: 0)
        case .down:
            edgeInset = UIEdgeInsets(top: 1, left: 0, bottom: 11, right: 0)
        case .left:
            edgeInset = UIEdgeInsets(top: 1, left: 11, bottom: 1, right: 0)
        case .right:
            edgeInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 11)
        }
        let resizableImage = arrowImage.resizableImage(withCapInsets: edgeInset!)
        return resizableImage
    }

    private class func configureForArrowDrawing(_ context: CGContext) {
        context.setBlendMode(CGBlendMode.normal)
        context.setAllowsAntialiasing(true)
        context.setShouldAntialias(true)
    }

    private class func strokeArrow(_ context: CGContext, size: CGSize, arrowColor: UIColor, backgroundColor: UIColor, lineWidth: CGFloat = 1.0, direction: ArrowDirection) {
        backgroundColor.setFill()
        UIRectFill(CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        arrowColor.setStroke()
        context.setLineWidth(lineWidth)

        let lineWidthOffset = lineWidth / 2 // needed to make the arrow pointy.

        switch direction {
        case .up:
            context.move(to: CGPoint(x: size.width, y: size.height))
            context.addLine(to: CGPoint(x: size.width / 2, y: 0 + lineWidthOffset))
            context.addLine(to: CGPoint(x: 0, y: size.height))
        case .down:
            context.move(to: CGPoint(x: size.width, y: 0))
            context.addLine(to: CGPoint(x: size.width / 2, y: size.height - lineWidthOffset))
            context.addLine(to: CGPoint(x: 0, y: 0))
        case .left:
            context.move(to: CGPoint(x: size.width, y: 0))
            context.addLine(to: CGPoint(x: lineWidthOffset, y: size.height / 2))
            context.addLine(to: CGPoint(x: size.width, y: size.height))
        case .right:
            context.move(to: CGPoint(x: 0, y: 0))
            context.addLine(to: CGPoint(x: size.width - lineWidthOffset, y: size.height / 2))
            context.addLine(to: CGPoint(x: 0, y: size.height))
        }
        context.strokePath()
    }

    class func defaultSize(for direction: ArrowDirection) -> CGSize {
        switch direction {
        case .up, .down:
            return CGSize(width: 12, height: 7)
        case .left, .right:
            return CGSize(width: 7, height: 12)
        }
    }
}

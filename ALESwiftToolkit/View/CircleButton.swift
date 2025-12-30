//
//  Created by Alessio on 17/08/21
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//


import UIKit


@IBDesignable
/// A simple circular button that offer some customization,
/// Supports switch between system dark and light ui style.
class CircleButton: UIButton {
    
    // TODO: Rename into cbBorderColor.
    @IBInspectable var customBorderColor: UIColor = .clear {
        didSet {
            layer.borderColor = customBorderColor.cgColor
        }
    }
    
    // TODO: Rename into cbHighlightedBackgroundColor.
    @IBInspectable var customHighlightedBackgroundColor: UIColor? = nil
    
    // TODO: Rename into cbBackgroundColor.
    var customBackgroundColor: UIColor? {
        didSet {
            backgroundColor = customBackgroundColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }

    func initialSetup() {
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = customBorderColor.cgColor
    }

    override func prepareForInterfaceBuilder() {
        initialSetup()
        super.prepareForInterfaceBuilder()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width / 2
    }
    
    override var isHighlighted: Bool {
        didSet {
            Logger.debug("Circle button isHighlighted: \(isHighlighted)")
            if isHighlighted,
               let hightlightColor = customHighlightedBackgroundColor {
                backgroundColor = hightlightColor
            }
            else {
                backgroundColor = customBackgroundColor
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle else {
            return
        }
        
        layer.borderColor = customBorderColor.cgColor
    }
}

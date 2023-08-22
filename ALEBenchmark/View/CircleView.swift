//
//  Created by Alessio Orlando on 04/04/16.
//  Copyright © 2016 Alessio Orlando. All rights reserved.
//

import UIKit


@IBDesignable
/// A simple circular view that offer some customization,
/// Supports switch between system dark and light ui style.
class CircleView: UIView {
    // TODO: Rename into cvBorderColor
    @IBInspectable var cnBorderColor: UIColor = .clear {
        didSet {
            layer.borderColor = cnBorderColor.cgColor
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
        layer.borderColor = cnBorderColor.cgColor
    }

    override func prepareForInterfaceBuilder() {
        initialSetup()
        super.prepareForInterfaceBuilder()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width / 2
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle else {
            return
        }
        
        layer.borderColor = cnBorderColor.cgColor
    }
}

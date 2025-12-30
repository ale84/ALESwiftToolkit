//
//  Created by Alessio Orlando on 10/02/2020
//  Copyright © 2020 Alessio Orlando. All rights reserved.
//  

import UIKit

@IBDesignable
class ExpandTextButton: UIButton {
    
    @IBInspectable var cnBackgroundColor: UIColor? {
        didSet {
            backgroundColor = cnBackgroundColor
            configureShadow()
        }
    }
    
    @IBInspectable
    var cnTitleColor: UIColor? {
        didSet {
            setTitleColor(cnTitleColor, for: [])
        }
    }
    
    @IBInspectable
    var cnFontSize: CGFloat = 15 {
        didSet {
            titleLabel?.font = titleLabel?.font.withSize(cnFontSize)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    private func initialSetup() {
        
        setTitle(NSLocalizedString("more", comment: ""), for: .normal)
        
        layer.cornerRadius = 10
        
        contentHorizontalAlignment = .trailing
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
                
        //configureTitleColor()
        
        configureShadow()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initialSetup()
    }
    
    private func configureShadow() {
        guard let backgroundColor = backgroundColor else {
            return
        }
        
        layer.shadowColor = backgroundColor.cgColor
        layer.shadowOffset = CGSize(width: -16, height: 0)
        layer.shadowOpacity = 0.75
        layer.shadowRadius = 6.0
    }
    
//    private func configureTitleColor() {
//        switch buttonType {
//        case .custom:
//            setTitleColor(theme.mainColor, for: [])
//        default:
//            tintColor = theme.mainColor
//        }
//    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle else {
            return
        }
        
        configureShadow()
    }
}

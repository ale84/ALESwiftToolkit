//
//  Created by Alessio Orlando on 10/02/2020
//  Copyright © 2025 Alessio Orlando. All rights reserved.
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
        
        configuration = .borderless()
        
        configuration?.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 0)
        
        // Add a string for each localization you want to support in Localizable.strings
        configuration?.title = NSLocalizedString("more", comment: "")
        
        configuration?.cornerStyle = .dynamic
        
        configuration?.titleAlignment = .trailing
        
        // Register for size class changes on self. Declare the first paramteter as `self: Self`.
        // Declaring self as the first parameter eliminates the need to capture self from outside the closure, and avoids strong reference cycles.
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self])
            { (self: Self, previousTraitCollection: UITraitCollection) in
                
                self.handleUserInterfaceStyleChange(previousTraitCollection)
            }
        }
        
        configureShadow()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        Task { @MainActor in
            self.initialSetup()
        }
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        if #unavailable(iOS 17.0) {
            super.traitCollectionDidChange(previousTraitCollection)
            
            guard let previousTraitCollection = previousTraitCollection else {
                return
            }
            
            handleUserInterfaceStyleChange(previousTraitCollection)
        }
    }
    
    private func handleUserInterfaceStyleChange(_ previousTraitCollection: UITraitCollection) {
        
        guard previousTraitCollection.userInterfaceStyle != traitCollection.userInterfaceStyle else {
            return
        }
        
        configureShadow()
    }
}


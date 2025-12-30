//
//  Created by Alessio on 11/08/2020
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//


import UIKit

@IBDesignable
/// A simple view with rounded corners.
class RoundedView: UIView {
    
    static private let cornerRadius: CGFloat = 16.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    private func initialSetup() {
        layer.cornerRadius = RoundedView.cornerRadius
        
        directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: RoundedView.cornerRadius,
            leading: RoundedView.cornerRadius,
            bottom: RoundedView.cornerRadius,
            trailing: RoundedView.cornerRadius)
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initialSetup()
    }
}

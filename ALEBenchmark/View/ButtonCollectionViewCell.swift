//
//  Created by Alessio Orlando on 29/08/2019
//  Copyright © 2019 Alessio Orlando. All rights reserved.
//  

import UIKit

/// A simple and generic collection view cell with a single button which takes up the whole size of the cell.
class ButtonCollectionViewCell: UICollectionViewCell {
    typealias Action = ((UIButton) -> Void)

    @IBOutlet weak var button: UIButton!
    var action: Action?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let buttonFont = UIFontMetrics.default.scaledFont(for: button.titleLabel!.font)
        button.titleLabel?.font = buttonFont
        button.titleLabel?.adjustsFontForContentSizeCategory = true
    }

    override func prepareForReuse() {
        action = nil
        button.setTitle(nil, for: [.normal])
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        action?(sender)
    }
}

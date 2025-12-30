//
//  Created by Alessio Orlando on 08/05/18.
//  Copyright © 2018 Alessio Orlando. All rights reserved.
//

import UIKit

/// A simple and generic table view cell with a single button which takes up the whole size of the cell.
class ButtonTableViewCell: UITableViewCell {
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

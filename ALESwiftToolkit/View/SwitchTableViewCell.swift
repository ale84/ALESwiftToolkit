//
//  Created by Alessio Orlando on 29/05/2019.
//  Copyright © 2019 Alessio Orlando. All rights reserved.
//

import UIKit

/// A table view cell with a title on the left side and a switch on the right.
class SwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var `switch`: UISwitch!

    override func prepareForReuse() {
        titleLabel.text = nil
        self.switch.isOn = false
        self.switch.removeTarget(nil, action: nil, for: .allEvents)
    }
}

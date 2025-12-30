//
//  Created by Alessio Orlando on 01/08/2019
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//  

import UIKit


/// A generic table view cell to display a setting option with a title on the left side and a value on the right.
class OptionDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var optionTitleLabel: UILabel!
    @IBOutlet weak var optionValueLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        optionTitleLabel.text = nil
        optionValueLabel.text = nil
    }
}

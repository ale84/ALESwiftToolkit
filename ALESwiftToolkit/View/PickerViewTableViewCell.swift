//
//  Created by Alessio on 10/09/2020
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//


import UIKit

/// A simple table view cell with a picker view.
class PickerViewTableViewCell: UITableViewCell {

    @IBOutlet weak var pickerView: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

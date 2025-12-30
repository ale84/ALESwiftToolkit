//
//  Created by Alessio Orlando on 28/11/2019
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//  

import UIKit

///  A table view cell with a text field
class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
        textField.delegate = nil
        textField.removeTarget(nil, action: nil, for: .allEvents)
    }
}



//
//  Created by Alessio Orlando on 17/05/2019.
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//

import UIKit

/// A simple table view cell suitable to display an error message.
class ErrorMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
    }
}

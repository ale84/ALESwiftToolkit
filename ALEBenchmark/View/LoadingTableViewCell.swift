//
//  Created by Alessio Orlando on 08/05/18.
//  Copyright © 2018 Alessio Orlando. All rights reserved.
//

import UIKit

/// A simple table view cell with a loading indicator and a message.
class LoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func prepareForReuse() {
        messageLabel.text = nil
    }

}

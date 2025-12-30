//
//  Created by Alessio on 29/04/2020
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//


import UIKit

/// A generic table view cell with a title on the left side and a value on the right side.
class RightDetailTableViewCell: UITableViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
        accessoryType = .none
    }
    
}

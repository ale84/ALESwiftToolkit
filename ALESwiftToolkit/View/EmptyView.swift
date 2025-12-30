//
//  Created by Alessio Orlando on 28/01/2019.
//  Copyright © 2019 Alessio Orlando. All rights reserved.
//

import UIKit

/// An empty view with an image and a text label.
class EmptyView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    class func instanciateFromNib() -> EmptyView {
        return Bundle.main.loadNibNamed("EmptyView", owner: nil, options: nil)![0] as! EmptyView
    }
}

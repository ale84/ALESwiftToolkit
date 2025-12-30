//
//  Created by Alessio Orlando on 28/11/2019
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//  

import UIKit

/// A table view cell with a text view.
class TextViewTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textView.text = nil
        textView.delegate = nil
    }
}

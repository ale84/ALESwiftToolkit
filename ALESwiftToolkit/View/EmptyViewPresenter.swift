//
//  Created by Alessio Orlando on 28/01/2019.
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//

import UIKit

class EmptyViewPresenter {
    
    var message: String
    var image: UIImage
    
    init(with message: String, image: UIImage) {
        self.message = message
        self.image = image
    }
}

extension EmptyView {
    func configure(with presenter: EmptyViewPresenter) {
        messageLabel.text = presenter.message
        imageView.image = presenter.image
    }
}

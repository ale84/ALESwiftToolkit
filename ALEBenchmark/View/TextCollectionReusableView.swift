//
//  Created by Alessio Orlando on 11/07/2019
//  Copyright © 2019 Alessio Orlando. All rights reserved.
//  

import UIKit

/// A collection reusable view with a text label.
class TextCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var textLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
    }
}

extension TextCollectionReusableView {
    func configure(with viewModel: CollectionViewTextHeaderFooterPresenter) {
        textLabel.text = viewModel.text
    }
}

class CollectionViewTextHeaderFooterPresenter {
    let text: String

    init(with text: String) {
        self.text = text
    }
}

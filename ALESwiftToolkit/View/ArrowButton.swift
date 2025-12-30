//
//  Created by Alessio Orlando on 08/03/18.
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//

import UIKit

/// An arrow button for expanding views. Default state arrow points down, selected points up.
@IBDesignable
class ArrowButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }

    func initialSetup() {
        let downArrow = ArrowImageGenerator.generateArrow(withDirection: .down)
        let upArrow = ArrowImageGenerator.generateArrow(withDirection: .up)
        setImage(downArrow, for: [])
        setImage(upArrow, for: .selected)
        addTarget(self, action: #selector(buttonPressedAction), for: .touchDown)
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initialSetup()
    }

    @objc func buttonPressedAction(_ sender: UIButton) {
        isSelected = !isSelected
        sendActions(for: .valueChanged)
    }

}

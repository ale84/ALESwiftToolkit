//
//  Created by Alessio on 31/07/23
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//



import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let arrowImage = ArrowImageGenerator.generateArrow(
            withDirection: .right,
            size: .init(width: 120, height: 70),
            lineWidth: 6,
            arrowColor: .red)
        
        let imageView = UIImageView(image: arrowImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}


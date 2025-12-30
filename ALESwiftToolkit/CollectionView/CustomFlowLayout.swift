//
//  Created by Alessio Orlando on 12/07/2019
//  Copyright © 2024 Alessio Orlando. All rights reserved.
//  

import UIKit

private let separatorDecorationView = "separator"

final class CustomFlowLayout: UICollectionViewFlowLayout {

    override func awakeFromNib() {
        super.awakeFromNib()
        register(SeparatorView.self, forDecorationViewOfKind: separatorDecorationView)
    }

    override init() {
        super.init()
        register(SeparatorView.self, forDecorationViewOfKind: separatorDecorationView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard  let layoutAttributes = super.layoutAttributesForElements(in: rect),
            let collectionView = collectionView,
            let dataSource = collectionView.dataSource,
            let sections = dataSource.numberOfSections?(in: collectionView) else {
                return super.layoutAttributesForElements(in: rect)
        }

        var decorationAttributes: [UICollectionViewLayoutAttributes] = []

        (0 ..< sections).forEach { (section) in

            let items = dataSource.collectionView(collectionView, numberOfItemsInSection: section)

            guard items > 0 else {
                return
            }

            if let topSeparatorAttributes = layoutAttributesForDecorationView(ofKind: separatorDecorationView, at: IndexPath(item: 0, section: section)) {
                decorationAttributes.append(topSeparatorAttributes)
            }

            if let bottomSeparatorAttributes = layoutAttributesForDecorationView(ofKind: separatorDecorationView, at: IndexPath(item: 1, section: section)) {
                decorationAttributes.append(bottomSeparatorAttributes)
            }
        }

        return layoutAttributes + decorationAttributes
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView,
            let dataSource = collectionView.dataSource else {
                return nil
        }

        let layoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: separatorDecorationView, with: indexPath)

        let section = indexPath.section
        let itemsCount = dataSource.collectionView(collectionView, numberOfItemsInSection: section)

        switch (indexPath.section, indexPath.row) {
        case (section, 0):  // top separator
            guard let firstItemAttributes = layoutAttributesForItem(at: IndexPath(item: 0, section: section)) else {
                return nil
            }

            let firstItemFrame = firstItemAttributes.frame
            layoutAttributes.frame = CGRect(x: collectionView.frame.origin.x, y: firstItemFrame.origin.y - 0.5, width: collectionView.frame.width, height: 0.5)

            return layoutAttributes

        case (section, 1):  // bottom separator
            guard let lastItemAttributes = layoutAttributesForItem(at: IndexPath(item: itemsCount - 1, section: section)) else {
                return nil
            }

            let lastItemFrame = lastItemAttributes.frame
            layoutAttributes.frame = CGRect(x: collectionView.frame.origin.x, y: lastItemFrame.maxY + 0.5, width: collectionView.frame.width, height: 1.0 / UIScreen.main.nativeScale)

            return layoutAttributes
        default:
            return nil
        }
    }
}

final class SeparatorView: UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        self.frame = layoutAttributes.frame
    }
}

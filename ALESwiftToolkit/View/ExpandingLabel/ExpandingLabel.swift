//
//  Created by Alessio on 24/03/2020
//  Copyright © 2020 Alessio Orlando. All rights reserved.
//

import UIKit

protocol ExpandingLabelDelegate: AnyObject {
    func didExpand(label: ExpandingLabel)
}

@IBDesignable
/// A label suitable to display a long text.
/// Default state, text is truncated after a set number of lines.
/// An arrow button allows expansion of the label to display the text in its entirety.
/// Delegate is called upon label expansion.
class ExpandingLabel: UIView {

    weak var delegate: ExpandingLabelDelegate?
    
    @IBInspectable
    var text: String? {
        set {
            titleLabel.text = newValue
            titleLabel.layoutIfNeeded()
        }
        get {
            titleLabel.text
        }
    }
    
    @IBInspectable
    var numberOfLines: Int {
        set {
            titleLabel.numberOfLines = newValue
            titleLabel.layoutIfNeeded()
        }
        get {
            titleLabel.numberOfLines
        }
    }

    lazy private(set) var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.adjustsFontForContentSizeCategory = true
        return titleLabel
    }()
    
    lazy private(set) var expandButton: ExpandTextButton = {
        let button = ExpandTextButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self,
                         action: #selector(expandLabel(_:) as (ExpandTextButton) -> Void),
                         for: .touchUpInside)
        
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        
        button.titleLabel?.font = titleLabel.font
        
        if #available(iOS 13.0, *) {
            button.cnBackgroundColor = .systemBackground
        }
        else {
            button.cnBackgroundColor = .white
        }
        
        return button
    }()
    
    private(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self,
                                      action: #selector(expandLabel(_:) as (UITapGestureRecognizer) -> Void))
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    private func initialSetup() {
        backgroundColor = .clear
        isOpaque = false
        
        addSubview(titleLabel)
        addSubview(expandButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            expandButton.rightAnchor.constraint(equalTo: rightAnchor),
            expandButton.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor)
        ])
        
        addGestureRecognizer(tapGestureRecognizer)
        
        expandButton.tintColor = tintColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        expandButton.isHidden = !titleLabel.el_isTruncated || titleLabel.text.el_isNilOrEmpty
    }
    
    private func expandLabel() {
        titleLabel.numberOfLines = 0
        expandButton.isHidden = true
        delegate?.didExpand(label: self)
    }
    
    @objc(expandLabelFromButton:)
    private func expandLabel(_ sender: ExpandTextButton) {
        expandLabel()
    }
    
    @objc(expandLabelFromTapRecognizer:)
    private func expandLabel(_ sender: UITapGestureRecognizer) {
        expandLabel()
    }
}

private protocol ELOptionalString {}
extension String: ELOptionalString {}

private extension Optional where Wrapped: ELOptionalString {
    var el_isNilOrEmpty: Bool {
        return ((self as? String) ?? "").isEmpty
    }
}

private extension UILabel {
    var el_isTruncated: Bool {

        guard let labelText = text else {
            return false
        }

        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font as Any],
            context: nil).size

        return labelTextSize.height > bounds.size.height
    }
}

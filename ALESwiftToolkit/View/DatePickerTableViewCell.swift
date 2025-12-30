//
//  Created by Alessio Orlando on 24/07/2019
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//  

import UIKit

protocol DatePickerCellDelegate: AnyObject {
    func didPickDate(date: Date, from cell: DatePickerTableViewCell)
}

/// A simple table view cell with a date picker.
/// Implement the delegate to get the selected date.
class DatePickerTableViewCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: DatePickerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    @IBAction func dateDidChange(_ sender: UIDatePicker) {
        delegate?.didPickDate(date: sender.date, from: self)
    }
}

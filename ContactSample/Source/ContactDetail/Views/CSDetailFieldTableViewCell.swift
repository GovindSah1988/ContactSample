//
//  CSDetailFieldTableViewCell.swift
//  ContactSample
//
//  Created by Govind Sah on 07/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

class CSDetailFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var entryTF: UITextField!
    @IBOutlet weak var titleWidthALC: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleWidthALC.constant = CGFloat(CSConstants.CSWidthConstraint.titleMaxWidth)
    }
}

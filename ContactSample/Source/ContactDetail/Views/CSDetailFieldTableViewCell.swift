//
//  CSDetailFieldTableViewCell.swift
//  ContactSample
//
//  Created by Govind Sah on 07/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

protocol CSEditTextFieldDelegate: NSObject {
    func textEdited(finalText: String?, type: CSContactDetailRow)
}

public class CSDetailFieldTableViewCell: UITableViewCell {

    var type: CSContactDetailRow!
    
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var entryTF: UITextField!
    @IBOutlet weak var titleWidthALC: NSLayoutConstraint!
    
    weak var editFieldDelegate: CSEditTextFieldDelegate?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        entryTF.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.titleWidthALC.constant = CGFloat(CSConstants.CSWidthConstraint.titleMaxWidth)
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        self.entryTF.isEnabled = true
        self.titleLB.text = ""
    }
    
    @objc func textDidChange() {
        self.editFieldDelegate?.textEdited(finalText: entryTF.text, type: type)
    }
    
    func configure(type: CSContactDetailRow, title: String, textFieldText: String?) {
        self.type = type
        titleLB.text = title
        entryTF.text = textFieldText
    }
}

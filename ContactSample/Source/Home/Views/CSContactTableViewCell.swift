//
//  CSContactTableViewCell.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

class CSContactTableViewCell: UITableViewCell {
    
    struct CSConstantsValues {
        static let contactIVCornerRadius: CGFloat = 20.0
    }

    var contact: CSContact! {
        didSet {
            contactIV.loadImage(fromURL: contact.profilePic)
            nameLB.text = contact.name
        }
    }
    
    @IBOutlet weak var contactIV: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var favouriteIV: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contactIV.layer.cornerRadius = CSContactTableViewCell.CSConstantsValues.contactIVCornerRadius
        self.contactIV.clipsToBounds = true
        favouriteIV.isHidden = false
    }
    
    override func prepareForReuse() {
        contactIV.image = UIImage()
        nameLB.text = ""
        favouriteIV.isHidden = true
    }
}

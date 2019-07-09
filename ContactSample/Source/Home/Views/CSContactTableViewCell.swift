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
            if let profileUrl = contact.profilePic {
                contactIV.loadImage(fromURL: profileUrl)
            }
            nameLB.text = contact.name
            favouriteIV.isHidden = !(contact.favorite ?? false)
        }
    }
    
    @IBOutlet weak var contactIV: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var favouriteIV: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contactIV.layer.cornerRadius = CSContactTableViewCell.CSConstantsValues.contactIVCornerRadius
        self.contactIV.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        contactIV.image = #imageLiteral(resourceName: "placeholder_photo")
        nameLB.text = ""
        favouriteIV.isHidden = true
    }
}

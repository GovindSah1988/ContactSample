//
//  CSStoryboardExtension.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

extension UIStoryboard {
    /// returns main story board
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: CSConstants.CSStoryboardConstants.main, bundle: nil)
    }
}

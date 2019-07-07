//
//  CSAppearanceManager.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

struct CSAppearanceManager {
    
    static func setupAppearance() {
        UIBarButtonItem.appearance().tintColor = UIColor.greenColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.titleColor]
    }
    
}

//
//  CSExtensions.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIImageView Extension

public extension UIImageView {
    func loadImage(fromURL url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }
        
        let cache =  URLCache.shared
        let request = URLRequest(url: imageURL)
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.transition(toImage: image)
                }
            } else {
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            self.transition(toImage: image)
                        }
                    }
                }).resume()
            }
        }
    }
    
    func transition(toImage image: UIImage?) {
        UIView.transition(with: self, duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.image = image
        },
                          completion: nil)
    }
}

// MARK: - NSObject Extension

public extension NSObject {
    
    /// Returns class name string
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

// MARK: - UIColor Extension

public extension UIColor {
    
    /// Returns class name string
    class var appGreenColor: UIColor {
        return UIColor(red: 0.0, green: 229.0/255.0, blue: 195.0/255.0, alpha: 1.0)
    }
    
    class var titleColor: UIColor {
        return UIColor(red: 0.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    
    class var gradientBottomColor: UIColor {
        return UIColor(red: 217.0/255.0, green: 244.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    }
    
    class var gradientTopColor: UIColor {
        return UIColor(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0)
    }
}

// MARK: - UINavigationController Extension

public extension UINavigationController {
    
    func pushFromBottomToTop(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        self.view.layer.add(transition, forKey: kCATransition)
        self.pushViewController(viewController, animated: false)
    }
    
    func popFromTopToBottom() {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.layer.add(transition, forKey: kCATransition)
        self.popViewController(animated: false)
    }
}

// MARK: - UIButton Extension

public extension UIButton {
    
    func alignTextBelow(spacing: CGFloat = 8.0) {
        if let image = self.imageView?.image {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font!])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
    
}

// MARK: - String Extension

public extension String {
    
    func isValidEmail() -> Bool {
        let emailRegExpression = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@+[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegExpression)
        return emailTest.evaluate(with: self)
    }
    
    // phoneNum must be more atleast 10 digit
    func isValidPhoneNumber() -> Bool {
        let phoneNumRegExpression = "^[+]*[0-9]{10,}$"
        let phoneNumTest = NSPredicate(format: "SELF MATCHES %@", phoneNumRegExpression)
        return phoneNumTest.evaluate(with: self)
    }

    /**
     to remove spaces and hyphen from the phone string
     */
    func removeSpaceAndSpecialCharacter() -> String {
        let string = self.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").removingPercentEncoding!
        return string
    }

    /// append next word to the existing word
    /// with space in between
    func appendNextWord(_ nextWord: String?) -> String {
        
        // return self in case next word is not there
        guard let nextWord = nextWord, 0 != nextWord.count else {
            return self
        }
        
        var finalWord = self
        
        // in case the first word is empty or nil
        // the final word is the next word itself
        if self.count == 0 {
            finalWord = nextWord
        } else {
            // else append next word to existing word
            finalWord = self + " " + nextWord
        }
        return finalWord
    }
}

// MARK: - UIViewController Extension

public extension UIViewController {
    
    /// to present an alert from a ViewController with only OK button.
    func presentOkAlert(title: String? = nil, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: CSConstants.CSLocalizedStringConstants.alertOk, style: .default, handler: handler)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// to present an alert from a ViewController with OK and Cancel buttons.
    func presentOkWithCancelAlert(title: String? = nil, message: String, okhandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: CSConstants.CSLocalizedStringConstants.alertOk, style: .default, handler: okhandler)
        let cancelAction = UIAlertAction(title: CSConstants.CSLocalizedStringConstants.alertCancel, style: .default)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UIViewController Extension

public extension Notification.Name {
    static let ContentDidUpdate = Notification.Name("eContentDidUpdate")
}

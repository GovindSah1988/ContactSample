//
//  CSContactDetailViewController.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

class CSContactDetailViewController: UIViewController {
    
    struct CSConstantsValues {
        static let rowHeight: CGFloat = 56.0
        static let numberOfCells: Int = 2
        static let maxTitleWidthValue = 52.5
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableViewHeightALC: NSLayoutConstraint!

    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var messageBT: UIButton!
    @IBOutlet weak var callBT: UIButton!
    @IBOutlet weak var emailBT: UIButton!
    @IBOutlet weak var favouriteBT: UIButton!
    
    var detailPresenter: CSContactDetailPresenter!
    
    var contact: CSContact!
    var gradient: CAGradientLayer!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.profileIV.layer.cornerRadius = self.profileIV.frame.size.width / 2.0
        self.profileIV.layer.borderColor = UIColor.white.cgColor
        self.profileIV.layer.borderWidth = 5.0
        self.profileIV.layer.masksToBounds = true
        self.profileIV.clipsToBounds = true
        
        addGradient()
    }
    
    private func addGradient() {
        
        if nil != gradient {
            gradient.removeFromSuperlayer()
        }
        
        gradient = CAGradientLayer()
        gradient.colors = [UIColor.gradientTopColor.cgColor, UIColor.gradientBottomColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.gradientView.frame.size.width, height: self.gradientView.frame.size.height)
        self.gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CSConstants.CSWidthConstraint.titleMaxWidth = CSConstantsValues.maxTitleWidthValue
        self.tableView.reloadData()
    }
    
    class func contactDetailVC() -> CSContactDetailViewController {
        let storyboard = UIStoryboard.mainStoryboard()
        let contactDetailVC = storyboard.instantiateViewController(withIdentifier: CSConstants.CSViewIdentifiers.contactDetailVC) as! CSContactDetailViewController
        return contactDetailVC
    }
    
    private func initialSetup() {
        registerCells()
        self.tableViewHeightALC.constant = CGFloat(CSContactDetailViewController.CSConstantsValues.numberOfCells) * CSContactDetailViewController.CSConstantsValues.rowHeight
        setupContactDetails()
        fetchContactDetail()
        setupButtons()
        setupNavigationBar()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func fetchContactDetail() {
        if let contact = contact {
            activityIndicator.startAnimating()
            detailPresenter = CSContactDetailPresenter(delegate: self)
            detailPresenter.fetchContactDetail(contact: contact)
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func setupContactDetails() {
        if nil != contact {
            if let profilePicUrl = contact.profilePic {
                self.profileIV.loadImage(fromURL: profilePicUrl)
            }
            self.favouriteBT.isSelected = contact.favorite ?? false
            self.nameLB.text = contact.name
            self.tableView.reloadData()
        }
    }

    private func registerCells() {
        tableView.register(UINib(nibName: CSDetailFieldTableViewCell.className, bundle: nil), forCellReuseIdentifier: CSDetailFieldTableViewCell.className)
    }
    
    private func setupButtons() {
        self.messageBT.setTitle("message", for: .normal)
        self.messageBT.alignTextBelow()
        
        self.callBT.setTitle("call", for: .normal)
        self.callBT.alignTextBelow()
        
        self.emailBT.setTitle("email", for: .normal)
        self.emailBT.alignTextBelow()
        
        self.favouriteBT.setTitle("favourite", for: .normal)
        self.favouriteBT.alignTextBelow()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editContactTapped))
        self.navigationController?.navigationBar.barTintColor = UIColor.gradientTopColor
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc func editContactTapped(_ button: UIBarButtonItem) {
        let editContactVC = CSAddEditContactViewController.editAddContactVC(editMode: .edit)
        editContactVC.contact = contact
        editContactVC.editDelegate = self
        self.navigationController?.pushFromBottomToTop(editContactVC)
    }

    @IBAction func deleteContact(_ sender: Any) {
        print("Delete Contact")
        self.presentOkWithCancelAlert(title: CSConstants.CSLocalizedStringConstants.alertDeleteTitle, message: CSConstants.CSLocalizedStringConstants.alertDeleteMessage) { [unowned self] (_) in
            self.activityIndicator.startAnimating()
            self.navigationController?.navigationBar.isUserInteractionEnabled = false
            self.detailPresenter.deleteContact(contact: self.contact)
        }
    }
    
    @IBAction func messageTapped(_ sender: UIButton) {
        print("messageTapped")
        if false == contact.phoneNumber?.isEmpty {
            // Make proper message API call
        }
    }
    
    @IBAction func callTapped(_ sender: UIButton) {
        print("callTapped")
        if let phoneNum = contact.phoneNumber, false == phoneNum.isEmpty {
            // Make proper phone call
            if let url = URL(string: "tel://\(phoneNum.removeSpaceAndSpecialCharacter())") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @IBAction func emailTapped(_ sender: UIButton) {
        print("emailTapped")
        if false == contact.email?.isEmpty {
            // Make proper email API call
        }
    }
    
    @IBAction func favouriteTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        // Make proper API call
        print("favouriteTapped")
        contact.favorite = sender.isSelected
        self.activityIndicator.startAnimating()
        self.detailPresenter.saveContact(contact: contact)
    }

}

extension CSContactDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CSContactDetailViewController.CSConstantsValues.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CSDetailFieldTableViewCell.className, for: indexPath) as! CSDetailFieldTableViewCell
        cell.entryTF.isEnabled = false
        if let contactRow = CSContactDetailRow(rawValue: indexPath.row + 2) {
            var textFieldText: String?
            switch contactRow {
            case .email:
                textFieldText = contact.email
            case .mobile:
                textFieldText = contact.phoneNumber
            default:
                textFieldText = ""
            }
            cell.configure(type: contactRow, title: contactRow.description, textFieldText: textFieldText)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CSContactDetailViewController.CSConstantsValues.rowHeight
    }
}

extension CSContactDetailViewController: CSContactDetailPresenterOutput {
    func deletedContact(contact: CSContact?, error: CSError?) {
        self.activityIndicator.stopAnimating()
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        if nil ==  error {
            NotificationCenter.default.post(name: Notification.Name.ContentDidUpdate, object: nil)
            self.presentOkAlert(title: nil, message: CSConstants.CSLocalizedStringConstants.deleteSuccessMessage) { [unowned self] (_) in
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.presentOkAlert(title: nil, message: CSConstants.CSLocalizedStringConstants.commonErrorInfo)
        }
    }
    
    func detailFetched(contact: CSContact?, error: CSError?) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.activityIndicator.stopAnimating()
        if let aContact = contact {
            self.contact = aContact
            self.tableView.reloadData()
        } else {
            // Show Error
            self.presentOkAlert(title: nil, message: CSConstants.CSLocalizedStringConstants.commonErrorInfo)
        }
    }
    
    func detailsUpdated(contact: CSContact?, error: CSError?) {
        self.activityIndicator.stopAnimating()
        if let aContact = contact {
            NotificationCenter.default.post(name: Notification.Name.ContentDidUpdate, object: nil)
            self.contact = aContact
        } else {
            // Show Error
            self.presentOkAlert(title: nil, message: CSConstants.CSLocalizedStringConstants.commonErrorInfo)
        }
    }
}

extension CSContactDetailViewController: CSEditContactDelegate {
    func contactEdited(contact: CSContact) {
        self.contact = contact
        self.setupContactDetails()
    }
}

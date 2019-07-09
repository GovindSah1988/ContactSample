//
//  CSAddEditContactViewController.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

enum CSContactEditMode {
    case edit
    case add
}

protocol CSEditContactDelegate: NSObject {
    func contactEdited(contact: CSContact)
}

class CSAddEditContactViewController: UIViewController {
    
    struct CSConstantsValues {
        static let rowHeight: CGFloat = 56.0
        static let numberOfCells: Int = 4
        static let maxTitleWidthValue = 83.0
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightALC: NSLayoutConstraint!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var editMode: CSContactEditMode!
    
    var contact: CSContact?
    weak var editDelegate: CSEditContactDelegate?
    
    var gradient: CAGradientLayer!

    var addEditPresenter: CSAddEditContactPresenter?
    
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

    class func editAddContactVC(editMode: CSContactEditMode) -> CSAddEditContactViewController {
        let storyboard = UIStoryboard.mainStoryboard()
        let editAddContactVC = storyboard.instantiateViewController(withIdentifier: CSConstants.CSViewIdentifiers.addEditContactVC) as! CSAddEditContactViewController
        editAddContactVC.editMode = editMode
        return editAddContactVC
    }
    
    private func initialSetup() {
        registerCells()
        setupUI()
        self.tableViewHeightALC.constant = CGFloat(CSConstantsValues.numberOfCells) * CSConstantsValues.rowHeight
        setupNavigationBar()
    }
    
    private func setupUI() {
        if editMode == .edit, let contact = contact {
            if let profilePic = contact.profilePic {
                self.profileIV.loadImage(fromURL: profilePic)
            }
            self.tableView.reloadData()
        }
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: CSDetailFieldTableViewCell.className, bundle: nil), forCellReuseIdentifier: CSDetailFieldTableViewCell.className)
    }

    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelContactTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneContactTapped))
        self.navigationItem.rightBarButtonItem?.isEnabled = canCreateContact()
    }
    
    @objc func cancelContactTapped(_ button: UIBarButtonItem) {
        self.navigationController?.popFromTopToBottom()
    }
    
    @objc func doneContactTapped(_ button: UIBarButtonItem) {
        if let contact = contact {
            self.activityIndicator.startAnimating()
            addEditPresenter = CSAddEditContactPresenter(delegate: self)
            addEditPresenter?.addEdit(contact: contact, editMode: editMode)
        }
    }
    
    @IBAction func uploadProfilePic(_ sender: Any) {
    }
    
    // add logic to test the validity of each text field
    private func canCreateContact() -> Bool {
        return (false == contact?.firstName.isEmpty) && (false == contact?.lastName.isEmpty) && (false == contact?.phoneNumber?.isEmpty) && (false == contact?.email?.isEmpty)
    }
}

extension CSAddEditContactViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CSConstantsValues.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CSDetailFieldTableViewCell.className, for: indexPath) as! CSDetailFieldTableViewCell
        cell.entryTF.isEnabled = true
        cell.editFieldDelegate = self
        if let contactRow = CSContactDetailRow(rawValue: indexPath.row) {
            var textFieldText: String?
            switch contactRow {
            case .email:
                textFieldText = contact?.email
            case .mobile:
                textFieldText = contact?.phoneNumber
            case .firstName:
                textFieldText = contact?.firstName
            case .lastName:
                textFieldText = contact?.lastName
            }
            cell.configure(type: contactRow, title: contactRow.description, textFieldText: textFieldText)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CSConstantsValues.rowHeight
    }
}

extension CSAddEditContactViewController: CSAddEditContactPresenterOutput {
    func didFinishAddEdit(contact: CSContact?, error: CSError?) {
        self.activityIndicator.stopAnimating()
        // dismiss controller
        if nil ==  error, let contact = contact {
            NotificationCenter.default.post(name: Notification.Name.ContentDidUpdate, object: nil)
            self.presentOkAlert(title: nil, message: CSConstants.CSLocalizedStringConstants.editAddSuccessMessage) { [weak self] (_) in
                self?.editDelegate?.contactEdited(contact: contact)
                self?.navigationController?.popFromTopToBottom()
            }
        } else {
            self.presentOkAlert(title: nil, message: CSConstants.CSLocalizedStringConstants.commonErrorInfo)
        }
    }
}

extension CSAddEditContactViewController: CSEditTextFieldDelegate {
    func textEdited(finalText: String?, type: CSContactDetailRow) {
        if nil == contact {
            contact = CSContact(id: nil)
        }
        switch type {
        case .email:
            contact?.email = finalText
        case .mobile:
            contact?.phoneNumber = finalText
        case .firstName:
            contact?.firstName = finalText!
        case .lastName:
            contact?.lastName = finalText!
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = canCreateContact()
    }
}


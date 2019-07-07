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
    @IBOutlet weak var tableViewHeightALC: NSLayoutConstraint!

    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var messageBT: UIButton!
    @IBOutlet weak var callBT: UIButton!
    @IBOutlet weak var emailBT: UIButton!
    @IBOutlet weak var favouriteBT: UIButton!
    
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
        setupButtons()
        setupNavigationBar()
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
    }
    
    @objc func editContactTapped(_ button: UIBarButtonItem) {
        let editContactVC = CSAddEditContactViewController.editAddContactVC(editMode: .edit)
        self.navigationController?.pushFromBottomToTop(editContactVC)
    }

    @IBAction func deleteContact(_ sender: Any) {
    }
}

extension CSContactDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CSContactDetailViewController.CSConstantsValues.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CSDetailFieldTableViewCell.className, for: indexPath) as! CSDetailFieldTableViewCell
        cell.titleLB.text = CSContactDetailRow(rawValue: indexPath.row + 2)?.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CSContactDetailViewController.CSConstantsValues.rowHeight
    }
}

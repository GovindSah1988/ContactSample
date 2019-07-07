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

    var editMode: CSContactEditMode!
    
    var contact: CSContact?
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

    class func editAddContactVC(editMode: CSContactEditMode) -> CSAddEditContactViewController {
        let storyboard = UIStoryboard.mainStoryboard()
        let editAddContactVC = storyboard.instantiateViewController(withIdentifier: CSConstants.CSViewIdentifiers.addEditContactVC) as! CSAddEditContactViewController
        editAddContactVC.editMode = editMode
        return editAddContactVC
    }
    
    private func initialSetup() {
        registerCells()
        self.tableViewHeightALC.constant = CGFloat(CSConstantsValues.numberOfCells) * CSConstantsValues.rowHeight
        setupNavigationBar()
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: CSDetailFieldTableViewCell.className, bundle: nil), forCellReuseIdentifier: CSDetailFieldTableViewCell.className)
    }

    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelContactTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneContactTapped))
    }
    
    @objc func cancelContactTapped(_ button: UIBarButtonItem) {
        self.navigationController?.popFromTopToBottom()
    }
    
    @objc func doneContactTapped(_ button: UIBarButtonItem) {
        self.navigationController?.popFromTopToBottom()
    }
    
    @IBAction func uploadProfilePic(_ sender: Any) {
    }
}

extension CSAddEditContactViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CSConstantsValues.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CSDetailFieldTableViewCell.className, for: indexPath) as! CSDetailFieldTableViewCell
        cell.titleLB.text = CSContactDetailRow(rawValue: indexPath.row)?.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CSConstantsValues.rowHeight
    }
}

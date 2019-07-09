//
//  CSContactsViewController.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

class CSContactsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var homePresenter: CSHomePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    deinit {
        deregisterNotifications()
    }
    
    private func initialSetup() {
        self.tableView.sectionIndexColor = .lightGray
        registerNotifications()
        homePresenter = CSHomePresenter(delegate: self)
        reloadContent()
        setupNavigationBar()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadContent), name: NSNotification.Name.ContentDidUpdate, object: nil)
    }
    
    private func deregisterNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func reloadContent() {
        homePresenter.fetchContacts()
        self.tableView.isHidden = true
        self.activityIndicatorView.startAnimating()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = CSConstants.CSLocalizedStringConstants.homeTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContactTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Group", style: .plain, target: self, action: #selector(groupTapped))
    }
    
    @objc func addContactTapped(_ button: UIBarButtonItem) {
        let addContactVC = CSAddEditContactViewController.editAddContactVC(editMode: CSContactEditMode.add)
        self.navigationController?.pushFromBottomToTop(addContactVC)
    }
    
    @objc func groupTapped(_ button: UIBarButtonItem) {
        
    }
    
}

extension CSContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return homePresenter.numberOfContactsSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homePresenter.numberOfContacts(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CSContactTableViewCell.className, for: indexPath) as! CSContactTableViewCell
        cell.contact = homePresenter.contact(at: indexPath.section, row: indexPath.row)
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return homePresenter.sectionTitles()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return homePresenter.sectionTitle(at: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactDetailVC = CSContactDetailViewController.contactDetailVC()
        contactDetailVC.contact = homePresenter.contact(at: indexPath.section, row: indexPath.row)
        self.navigationController?.pushViewController(contactDetailVC, animated: true)
    }
}

extension CSContactsViewController: CSHomePresenterOutput {
    func contactsFetched(error: CSError?) {
        if nil == error {
            self.tableView.isHidden = false
            self.activityIndicatorView.stopAnimating()
            self.tableView.reloadData()
        } else {
            self.presentOkAlert(title: nil, message: CSConstants.CSLocalizedStringConstants.commonErrorInfo)
        }
    }
}

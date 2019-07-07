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
    
    private func initialSetup() {
        homePresenter = CSHomePresenter(delegate: self)
        homePresenter.fetchContacts()
        self.activityIndicatorView.startAnimating()
        setupNavigationBar()
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CSContactTableViewCell.className, for: indexPath)
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["A", "B"]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "A"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactDetailVC = CSContactDetailViewController.contactDetailVC()
        self.navigationController?.pushViewController(contactDetailVC, animated: true)
    }
}

extension CSContactsViewController: CSHomePresenterOutput {
    func contacts(_ contacts: [CSContact]?, error: CSError?) {
        self.activityIndicatorView.stopAnimating()
        self.tableView.reloadData()
    }
}

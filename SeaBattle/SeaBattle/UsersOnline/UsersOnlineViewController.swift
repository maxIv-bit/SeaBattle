//
//  UsersOnlineViewController.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import UIKit
import Firebase

final class UsersOnlineViewController: BaseViewController<UsersOnlineViewModel> {
    private lazy var usersRef = Database.database().reference(withPath: "online")
    private lazy var tableView = UITableView()
    private lazy var dataSource = UsersOnlineTableViewDataSource(tableView: tableView)
    private lazy var currentUsers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attachViews()
        configureUI()
        configureBindings()
    }
    
    override func performOnceInViewWillAppear() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

//  MARK: - Private
private extension UsersOnlineViewController {
    func attachViews() {
        [tableView].forEach(view.addSubview)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(rightBarButtonItemAction))
    }
    
    func configureBindings() {
        viewModel.onError = { error in
            UIAlertController.showOkAlert(message: error, viewController: UIViewController.pvc())
        }
        
        dataSource.didSelect = { _, _ in
            
        }
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            let currentUserRef = self.usersRef.child(user.uid)
            currentUserRef.setValue(user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
        
        usersRef.observe(.childAdded, with: { snap in
            guard let email = snap.value as? String else { return }
            self.currentUsers.append(email)
            let row = self.currentUsers.count - 1
            self.dataSource.insert(index: row, data: email)
        })
        
        usersRef.observe(.childRemoved, with: { snap in
            guard let emailToFind = snap.value as? String else { return }
            for (index, email) in self.currentUsers.enumerated() {
                if email == emailToFind {
                    self.currentUsers.remove(at: index)
                    self.dataSource.delete(at: index)
                }
            }
        })
    }
    
    @objc func rightBarButtonItemAction(_ sender: UIBarButtonItem) {
        viewModel.logOut()
    }
}

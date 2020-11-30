//
//  RoomsViewController.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import UIKit
import Firebase

final class RoomsViewController: BaseViewController<RoomsViewModel> {
    private lazy var tableView = UITableView()
    private lazy var dataSource = RoomsTableViewDataSource(tableView: tableView)
    
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
private extension RoomsViewController {
    func attachViews() {
        [tableView].forEach(view.addSubview)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(rightBarButtonItemAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Create room", style: .plain, target: self, action: #selector(leftBarButtonItemAction))
    }
    
    func configureBindings() {
        viewModel.onError = { error in
            UIAlertController.showOkAlert(message: error, viewController: UIViewController.pvc())
        }
        
        viewModel.didReceiveRooms = { [weak self] rooms in
            self?.dataSource.update(data: rooms, shouldReload: true)
        }
        
        dataSource.didSelect = { [weak self] _, indexPath in
            self?.viewModel.connectToRoom(at: indexPath)
        }
    }
    
    @objc func rightBarButtonItemAction(_ sender: UIBarButtonItem) {
        viewModel.logOut()
    }
    
    @objc func leftBarButtonItemAction(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Enter room name", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [weak self] alert -> Void in
            let roomName = alertController.textFields![0] as UITextField
            self?.viewModel.createRoom(name: roomName.text ?? "")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

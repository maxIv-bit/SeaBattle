//
//  TableViewDataSource.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import UIKit

class TableViewDataSource<T>: NSObject,
    UITableViewDelegate,
    UITableViewDataSource
{
    let tableView: UITableView
    var didSelect: ((T, IndexPath) -> Void)?
    lazy var data = [T]()

    init(tableView: UITableView) {
        self.tableView = tableView
        
        super.init()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configure()
    }
    
    func configure() {}
    func update(data: [T], shouldReload: Bool) {
        self.data = data
        
        if shouldReload {
            tableView.reloadData()
        }
    }
    
    func insert(index: Int, data: T) {
        let indexPathes = [IndexPath(item: index, section: 0)]
        self.data.insert(data, at: index)
        tableView.insertRows(at: indexPathes, with: .top)
    }
    
    func delete(at index: Int) {
        let indexPathes = [IndexPath(item: index, section: 0)]
        self.data.remove(at: index)
        tableView.deleteRows(at: indexPathes, with: .bottom)
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func reload(at indices: [Int]) {
        reload(at: indices.map { IndexPath(item: $0, section: 0) })
    }
    
    func reload(at indexPathes: [IndexPath]) {
        tableView.reloadRows(at: indexPathes, with: .automatic)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { data.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { nil }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { nil }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelect?(data[indexPath.row], indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { .zero }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { .zero }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { .zero }
}

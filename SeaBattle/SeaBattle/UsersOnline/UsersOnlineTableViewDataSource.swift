//
//  UsersOnlineTableViewDataSource.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import UIKit

final class UsersOnlineTableViewDataSource: TableViewDataSource<String> {
    override func configure() {
        tableView.register(UsersOnlineTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: UsersOnlineTableViewCell.self)
        cell.selectionStyle = .none
        let email = data[indexPath.row]
        cell.configure(email: email)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50.0
    }
}

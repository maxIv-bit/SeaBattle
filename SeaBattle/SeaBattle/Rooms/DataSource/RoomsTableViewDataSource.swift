//
//  RoomsTableViewDataSource.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import UIKit

final class RoomsTableViewDataSource: TableViewDataSource<Room> {
    override func configure() {
        tableView.register(RoomsTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: RoomsTableViewCell.self)
        cell.selectionStyle = .none
        let room = data[indexPath.row]
        cell.configure(name: room.name, usersCount: room.players.count)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50.0
    }
}

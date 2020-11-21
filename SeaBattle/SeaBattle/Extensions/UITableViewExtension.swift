//
//  UITableViewExtension.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import UIKit

extension UITableView {
    final func register<T: UITableViewCell>(_ cellType: T.Type) where T: Reusable {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func register<T: UITableViewCell>(_ cells: [T.Type]) where T: Reusable {
        cells.forEach(register)
    }
    
    final func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type) where T: Reusable {
        register(headerFooterViewType.self, forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UITableViewCell>(
        for indexPath: IndexPath,
        with cellType: T.Type = T.self
    ) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self).")
        }
        
        return cell
    }
    
    final func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(
        _ viewType: T.Type = T.self
    ) -> T? where T: Reusable {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as? T? else {
            fatalError("Failed to dequeue a header/footer with identifier \(viewType.reuseIdentifier) matching type \(viewType.self).")
        }
        
        return view
    }
}

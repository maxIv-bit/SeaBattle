//
//  TableViewCell.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import UIKit

class TableViewCell: UITableViewCell, Reusable {
    private lazy var layoutSubviewsWasCalled = false
    func performOnceOnLayoutSubviews() { }
    func configure() {}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !layoutSubviewsWasCalled {
            performOnceOnLayoutSubviews()
            layoutSubviewsWasCalled.toggle()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
}

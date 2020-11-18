//
//  ChainHandler.swift
//  SeaBattle
//
//  Created by Maks on 18.11.2020.
//

import Foundation

protocol ChainHandler {
    func setNext(_ handler: ChainHandler?)
    func processRequest()
}

class BaseChainHandler: ChainHandler {
    var nextHandler: ChainHandler?
    
    func setNext(_ handler: ChainHandler?) {
        nextHandler = handler
    }
    
    func processRequest() { }
}

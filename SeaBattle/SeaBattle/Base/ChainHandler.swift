//
//  ChainHandler.swift
//  SeaBattle
//
//  Created by Maks on 18.11.2020.
//

import Foundation

protocol ChainHandler {
    func setNext(_ handler: ChainHandler?)
    func processRequest(parameters: [String: Any?])
    func processError(error: Error)
}

class BaseChainHandler: ChainHandler {
    var nextHandler: ChainHandler?
    var onError: ((Error) -> Void)?
    
    func setNext(_ handler: ChainHandler?) {
        nextHandler = handler
    }
    
    func processRequest(parameters: [String: Any?]) { }
    
    func processError(error: Error) {
        if nextHandler != nil {
            nextHandler?.processError(error: error)
        } else {
            onError?(error)
        }
    }
}

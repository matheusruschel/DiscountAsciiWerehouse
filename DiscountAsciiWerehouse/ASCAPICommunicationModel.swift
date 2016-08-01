//
//  ASCAPICommunicationModel.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/1/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

typealias AsciiProductCompletionBlock = (object:ASCAsciiProduct,error:NSError?) -> Void

class ASCAPICommunicationModel {
    
    static let sharedInstance = ASCAPICommunicationModel()
    
    func fetchProducts(completion:AsciiProductCompletionBlock) {
        
        
        
    }
    
    
}
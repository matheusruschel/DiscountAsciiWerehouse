//
//  ASCAsciiProduct.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/1/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation


struct ASCProduct {
    
    var id: String
    var type: String
    var face: String
    var size: Int
    var price: Float
    var stock: Int
    var tags: [String]
    
}

extension ASCProduct : Wrappable {
    
     init?(data: AnyObject) {
        
        guard
            let id   = data["id"] as? String,
            let type = data["type"] as? String,
            let face = data["face"] as? String,
            let size = data["size"] as? Int,
            let price = data["price"] as? Float,
            let stock = data["stock"] as? Int,
            let tags = data["tags"] as? [String] else {
                return nil
        }
        
        price
        
        self.init(id:id, type:type, face:face , size:size, price:price, stock: stock, tags: tags)
    }
    
}
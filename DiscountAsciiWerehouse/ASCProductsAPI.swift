//
//  ASCProductsAPI.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/3/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation


typealias ProductsCompletionBlock = (() throws -> [ASCProduct]?) -> Void

class ASCProductsAPI {
    
    let api = ASCAPICommunicationModel()
    
    
    func fetchProducts(parameters: [PARAM:AnyObject], completion:ProductsCompletionBlock) {
        
        let urlBuilder = ASCUrlBuilder(param: parameters)
        
        if urlBuilder == nil {
            fatalError("Invalid parameters provided for ASCUrlBuilder")
        }
        let url = NSURL(string: urlBuilder!.finalUrl)
        guard let urlUw = url else {
            fatalError("Could not create url")
        }
        
        api.fetchData(urlUw) { callback in
        
            do {
                let callBackData = try callback()
                
                guard let dataList = callBackData as? [AnyObject] else {
                    completion({ throw Error.JSONNotRecognizedError })
                    return
                }
                
                completion({ return try dataList.map({ productData in
                    
                    let product = ASCProduct(data:productData)
                    
                    guard let productUw = product else {
                        throw Error.CouldNotCreateObjectWithDataFile
                    }
                    return productUw
                
                }) })
                
            } catch let error {
                completion({throw error})
            }
        
        }
        
    }
    
    
}
//
//  ASCProductsAPI.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/3/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation


typealias ProductsCompletionBlock = (() throws -> [ASCProduct]) -> Void

class ASCProductsAPI {
    
    let api = ASCAPICommunicationModel()

    func fetchProducts(searchText: String?, onlyStock:Bool, skip: Int, limit: Int, completion:ProductsCompletionBlock) {
        
        var parameters : [PARAM:AnyObject]!  = [PARAM.Limit : limit,
                                               PARAM.OnlyInStock: onlyStock,
                                               PARAM.Skip: skip]
        
        if searchText != nil {
            let encodedSearchText = String(htmlEncodedString: searchText!)
            parameters[PARAM.SearchTerm] = encodedSearchText
        }
        
        let url = specifyParametersForUrl(parameters)
        fetchProductsOnline(url,completion: completion)
        
    }
    
    private func specifyParametersForUrl(parameters:[PARAM:AnyObject]) -> NSURL {
        
        let url = ASCUrlBuilder.buildUrl(forParameters: parameters)
        guard let urlUw = url else {
            fatalError("Could not create url")
        }
        return urlUw
    }
    
    
    private func fetchProductsOnline(url: NSURL, completion: ProductsCompletionBlock) {
        
        api.fetchData(url) { callback in
            
            do {
                let callBackData = try callback()
                
                guard let dataList = callBackData as? [AnyObject] else {
                    completion({ throw Error.JSONNotRecognizedError })
                    return
                }
                
                let list: [ASCProduct] = try dataList.map({ productData in
                    
                    let product = ASCProduct(data:productData)
                    
                    guard let productUw = product else {
                        throw Error.CouldNotCreateObjectWithDataFile
                    }
                    
                    return productUw
                    
                })
                
                completion({ return list })
                
            } catch let error {
                completion({throw error})
            }
            
        }

        
    }
    
    
}
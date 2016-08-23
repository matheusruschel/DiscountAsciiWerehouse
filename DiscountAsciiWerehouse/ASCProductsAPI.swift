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
        
        let parameters : [PARAM]!  = [PARAM.Limit(amount: limit),
                                      PARAM.OnlyInStock(bool: onlyStock),
                                      PARAM.Skip(amount: skip),
                                      PARAM.SearchTerm(searchText: searchText)]
        
        let url = ASCUrlBuilder.buildUrl(forParameters: parameters)
        guard let urlUw = url else {
            fatalError("Could not create url")
        }
        
        fetchProductsOnline(urlUw,completion: completion)
        
    }
    
    internal func fetchProductsOnline(url: NSURL, completion: ProductsCompletionBlock) {
        
        api.fetchData(url) { callback in
            
            do {
                let callBackData = try callback()
                
                guard let dataList = callBackData as? [AnyObject] else {
                    completion({ throw Error.ErrorWithCode(errorCode: .NDJSONNotRecognizedError) })
                    return
                }
                
                let list: [ASCProduct] = try dataList.map({ productData in
                    
                    let product = ASCProduct(data:productData)
                    
                    guard let productUw = product else {
                        throw Error.ErrorWithCode(errorCode: .CouldNotCreateObjectWithDataFile)
                    }
                    
                    return productUw
                    
                })
                
                completion({ return list })
                
            } catch {
                completion({throw error})
            }
            
        }

        
    }
    
    
}
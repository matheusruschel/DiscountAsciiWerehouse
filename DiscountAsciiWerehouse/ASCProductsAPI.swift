//
//  ASCProductsAPI.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/3/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

class ASCProductsAPI : ProductsAPIProtocol {
    
    let api = ASCAPICommunicationModel()

    func fetchProducts(searchText: String?, onlyStock:Bool, skip: Int, limit: Int, completion:ProductsCompletionBlock) {
        
        var parameters : [PARAM:AnyObject]!  = [PARAM.Limit : limit,
                                               PARAM.OnlyInStock: onlyStock,
                                               PARAM.Skip: skip]
        
        
        if let searchString = searchText {
            if searchString.stringByReplacingOccurrencesOfString(" ", withString: "") != "" {
                let encodedSearchText = String(htmlEncodedString: searchString).stringByReplacingOccurrencesOfString(" ", withString: "")
                parameters[PARAM.SearchTerm] = encodedSearchText
            }
        }
        
        let url = specifyParametersForUrl(parameters)
        fetchProductsOnline(url,completion: completion)
        
    }
    
    internal func specifyParametersForUrl(parameters:[PARAM:AnyObject]) -> NSURL {
        
        let url = ASCUrlBuilder.buildUrl(forParameters: parameters)
        guard let urlUw = url else {
            fatalError("Could not create url")
        }
        return urlUw
    }
    
    
    internal func fetchProductsOnline(url: NSURL, completion: ProductsCompletionBlock) {
        
        api.fetchData(url) { callback in
            
            do {
                let callBackData = try callback()
                
                guard let dataList = callBackData as? [AnyObject] else {
                    completion({ throw Error.ErrorWithCode(errorCode: .JSONNotRecognizedError) })
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
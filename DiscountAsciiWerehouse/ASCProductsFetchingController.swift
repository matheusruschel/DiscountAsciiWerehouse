//
//  ASCProductsFetchingController.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/5/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

typealias ProductControllerStatusCompletionBlock = (() throws -> ProductControllerCompletionBlockResult) -> Void

enum ProductControllerCompletionBlockResult {
    case LoadedNewProducts(products: [ASCProduct])
    case ReachedProductMaxLimit
    case NoResultsFound
}

class ASCProductsFetchingController {
    
    var productsAPI = ASCProductsAPI()
    private var paginatedProducts: [ASCProduct] = []
    private var onlyInStock: Bool! {
        willSet {
            if let onlyInStock = onlyInStock {
                if onlyInStock != newValue {
                    reset = true
                    maxLimitReached = false
                } else {
                    reset = false
                }
            }
        }
    }
    private var searchText: String? {
        willSet {
            if let searchText = searchText {
                if searchText != newValue {
                    reset = true
                    maxLimitReached = false
                } else {
                    reset = false
                }
            }
        }
    }
    private var reset = false
    private var maxLimitReached = false
    
    func fetchProducts(searchText: String?, onlyStock:Bool, completion:ProductControllerStatusCompletionBlock) {
        self.onlyInStock = onlyStock
        self.searchText = searchText
        
        // resets if search text changes or only in stock changes
        if reset {
            self.paginatedProducts.removeAll()
        }
        
        if !maxLimitReached {
            
            productsAPI.fetchProducts(searchText, onlyStock: onlyStock, skip: paginatedProducts.count) {
                productsCallBack in
                
                completion({
                    let fetchedProducts = try productsCallBack()
                    
                    if fetchedProducts.isEmpty {
                        self.maxLimitReached = true
                        return .ReachedProductMaxLimit
                    }
                    self.paginatedProducts.appendContentsOf(fetchedProducts)
                    return .LoadedNewProducts(products: self.paginatedProducts)
                })
            }
        } else {
            completion({return .ReachedProductMaxLimit})
        }
        
        
    }
    
    
}
//
//  ASCProductsFetchingController.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/5/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

enum ProductControllerResult {
    case LoadedNewProducts(products: [ASCProduct])
    case NoResultsFound
    case ReachedLimit(products: [ASCProduct])
}

class ASCProductsFetchingController : ASCProductsFetchingControllerProtocol {
    
    let productsAPI = ASCProductsAPI()
    internal var paginatedProducts: [ASCProduct] = []
    internal var onlyInStock: Bool! {
        willSet {
                if onlyInStock != newValue {
                    refresh = true
                }
        }
    }
    internal var searchText: String? {
        willSet {
                if searchText != newValue {
                    refresh = true
                }
        }
    }
    internal var refresh = false
    internal let requestLimit = 10
    
    
    func fetchProducts(searchText: String?, onlyStock:Bool,forceRefresh: Bool, completion:ProductControllerStatusCompletionBlock) {
        self.refresh = forceRefresh
        self.onlyInStock = onlyStock
        self.searchText = searchText
        
        // resets if search text changes or only in stock changes
        if self.refresh {
            self.paginatedProducts.removeAll()
            self.refresh = false
        }
        
            
        productsAPI.fetchProducts(searchText, onlyStock: onlyStock, skip: paginatedProducts.count,limit: requestLimit) {
            productsCallBack in
            
            completion({
                let fetchedProducts = try productsCallBack()
                
                if fetchedProducts.isEmpty && self.paginatedProducts.isEmpty {
                    return .NoResultsFound
                }
                
                if fetchedProducts.count < self.requestLimit {
                    
                    if fetchedProducts.count != 0 {
                        self.paginatedProducts.appendContentsOf(fetchedProducts)
                    }
                    return .ReachedLimit(products:self.paginatedProducts)
                }
                
                
                self.paginatedProducts.appendContentsOf(fetchedProducts)
                return .LoadedNewProducts(products: self.paginatedProducts)
            })
        }

        
    }
    
    
}
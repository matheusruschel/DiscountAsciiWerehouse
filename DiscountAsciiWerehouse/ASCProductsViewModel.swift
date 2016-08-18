//
//  ASCAsciiProductViewModel.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/1/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

enum FetchStatus {
    case LoadedNewProducts, NoResultsFound(msg:String), ReachedLimit(msg:String), Error(msg:String)
    
}

protocol ProductCoordinatorDelegate : class {
    
    func coordinatorDidFinishLoadingProducts(viewModel: ASCProductsViewModel, status:FetchStatus)
    func coordinatorDidStartSearching(viewModel: ASCProductsViewModel)
}


class ASCProductsViewModel {
    
    weak var delegate: ProductCoordinatorDelegate?
    private let productsController = ASCProductsFetchingController()
    private var products: [ASCProduct]?
    var numberOfItemsInSection: Int {
        var listSize = 0
        if let productsList = products {
            listSize += productsList.count
        }
        
        if showLoadingCell {
            listSize += 1 //cells + loading cell in case we have more results to fetch
        }
        return listSize
    }
    var showLoadingCell = true
    
    func validateSearchText(searchText: String?) -> Bool {
        
        // eliminates cases like phrases with only blank spaces
        if let searchText = searchText {
            
            if searchText != "" && searchText.stringByReplacingOccurrencesOfString(" ", withString: "") == "" {
                return false
            }
        }
        return true
        
    }
    
    func prepareToLoadWithNewParameters() {
        self.products?.removeAll()
        showLoadingCell = true
    }
    
    func loadProducts(searchText: String?, onlyInStock: Bool,forceRefresh:Bool) {
        
        showLoadingCell = true
        self.delegate?.coordinatorDidStartSearching(self)
        productsController.fetchProducts(searchText, onlyStock: onlyInStock,forceRefresh:forceRefresh) {
            
            statusCallBack in
            
            do {
                let status = try statusCallBack()
                
                var delegateStatus:FetchStatus!
                switch status {
                case .LoadedNewProducts(let newProducts):
                                                                self.products = newProducts
                                                                self.showLoadingCell = true
                                                                delegateStatus = .LoadedNewProducts
                case .NoResultsFound:
                                                                self.products = nil
                                                                self.showLoadingCell = true
                                                                delegateStatus = .NoResultsFound(msg: "No results found!")
                case .ReachedLimit(let newProducts):
                    
                                                                self.products = newProducts
                                                                self.showLoadingCell = false
                                                                delegateStatus = .ReachedLimit(msg: "Finished loading!")
                }
                
                self.delegate?.coordinatorDidFinishLoadingProducts(self, status: delegateStatus!)
                
            } catch _ {
                
                self.showLoadingCell = true
                self.delegate?.coordinatorDidFinishLoadingProducts(self, status: .Error(msg: "Oops, something went wrong..."))
            }
            
        }
        

        
    }
    
    func itemForIndexPath(index:Int) -> ASCProduct? {
        
        if let productsList = products {
            if index < productsList.count {
                return productsList[index]
            }
        }
        return nil
    }

}
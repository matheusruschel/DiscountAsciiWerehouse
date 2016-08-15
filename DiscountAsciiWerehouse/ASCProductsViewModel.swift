//
//  ASCAsciiProductViewModel.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/1/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

protocol ProductCoordinatorDelegate : class {
    
    func coordinatorDidFinishLoadingProducts(viewModel: ASCProductsViewModel, sucess:Bool,errorMsg: String?)
}


class ASCProductsViewModel {
    
    weak var delegate: ProductCoordinatorDelegate?
    private let productsController = ASCProductsFetchingController()
    var products: [ASCProduct]?
    var numberOfItemsInSection: Int {
        if let productsList = products {
            
            if showLoadingCell {
                return productsList.count + 1 //cells + loading cell in case we have more results to fetch
            }
            return productsList.count
        }
        return 0
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
    
    func clearProductsList() {
        self.products?.removeAll()
    }
    
    func loadProducts(searchText: String?, onlyInStock: Bool,forceRefresh:Bool) {
        
        showLoadingCell = false
        productsController.fetchProducts(searchText, onlyStock: onlyInStock,forceRefresh:forceRefresh) {
            
            statusCallBack in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                do {
                    let status = try statusCallBack()
                    
                    switch status {
                    case .LoadedNewProducts(let newProducts):       self.products = newProducts
                                                                    self.showLoadingCell = true
                    case .NoResultsFound:
                                                                    self.products = nil
                                                                    self.showLoadingCell = false
                    case .ReachedLimit(let newProducts):
                        
                        if newProducts.count != 0 {
                            self.products = newProducts
                        } 
                        self.showLoadingCell = false
                    }
                    
                    self.delegate?.coordinatorDidFinishLoadingProducts(self, sucess: true, errorMsg: nil)
                } catch let error as NSError {
                    self.delegate?.coordinatorDidFinishLoadingProducts(self, sucess: false, errorMsg: error.localizedDescription)
                }
            })
            
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
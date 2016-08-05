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
            return productsList.count
        }
        return 0
    }
    var maxProductLimitReached = false
    
    func validateSearchText(searchText: String?) -> Bool {
        
        // eliminates cases like phrases with only blank spaces
        if let searchText = searchText {
            if searchText.stringByReplacingOccurrencesOfString(" ", withString: "") == "" {
                return false
            }
        }
        return true
        
    }
    
    func loadProducts(searchText: String?, onlyInStock: Bool) {
        
            productsController.fetchProducts(searchText, onlyStock: onlyInStock) {
                
                statusCallBack in
                
                dispatch_sync(dispatch_get_main_queue(), {
                    
                    do {
                        let status = try statusCallBack()
                        
                        switch status {
                        case .LoadedNewProducts(let newProducts): self.products = newProducts
                                                                  self.maxProductLimitReached = false
                        case .ReachedProductMaxLimit: self.maxProductLimitReached = true
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
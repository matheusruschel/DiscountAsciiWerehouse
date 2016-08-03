//
//  ASCAsciiProductViewModel.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/1/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

protocol ProductCoordinatorDelegate {
    
    func coordinatorDidFinishLoadingProducts(viewModel: ASCProductViewModel, sucess:Bool,errorMsg: String?)
}


class ASCProductViewModel {
    
    var delegate: ProductCoordinatorDelegate?
    var products: [ASCProduct]?
    let productsAPI = ASCProductsAPI()
    
    func loadProducts() {
        
        productsAPI.fetchProducts([:],completion: { products in print(products)})
        delegate?.coordinatorDidFinishLoadingProducts(self, sucess: true, errorMsg: nil)
    }
    
    func loadProducts(searchText: String) {
        
        delegate?.coordinatorDidFinishLoadingProducts(self, sucess: true, errorMsg: nil)
    }

}
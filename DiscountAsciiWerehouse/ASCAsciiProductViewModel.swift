//
//  ASCAsciiProductViewModel.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/1/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

protocol AsciiProductCoordinatorDelegate {
    
    func coordinatorDidFinishLoadingProducts(viewModel: ASCAsciiProductViewModel, sucess:Bool,errorMsg: String?)
}


class ASCAsciiProductViewModel {
    
    var delegate: AsciiProductCoordinatorDelegate?
    
    func loadProducts() {
        
        delegate?.coordinatorDidFinishLoadingProducts(self, sucess: true, errorMsg: nil)
    }
    
    func loadProducts(searchText: String) {
        
        delegate?.coordinatorDidFinishLoadingProducts(self, sucess: true, errorMsg: nil)
    }

}
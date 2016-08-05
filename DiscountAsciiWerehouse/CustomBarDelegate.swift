//
//  CustomBarDelegate.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/5/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

protocol CustomSearchControllerDelegate {
    
    func didStartSearching()
    
    func didTapOnSearchButton()
    
    func didTapOnCancelButton()
    
    func didChangeSearchText(searchText: String)
}
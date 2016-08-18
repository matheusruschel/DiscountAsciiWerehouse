//
//  ProductsAPIProtocol.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/18/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

typealias DataCallbackCompletionBlock =  (() throws -> AnyObject?) -> Void

protocol APICommunicationModelProtocol {
    var session: NSURLSession! {get}
    var cache: CustomCache<NSData>! {get}
    func fetchData(url:NSURL, completion:DataCallbackCompletionBlock)
    func fetchDataOnline(url: NSURL, completion:DataCallbackCompletionBlock)
    func cancelDataRequests()
}


typealias ProductsCompletionBlock = (() throws -> [ASCProduct]) -> Void

protocol ProductsAPIProtocol {
    
    func fetchProducts(searchText: String?, onlyStock:Bool, skip: Int, limit: Int, completion:ProductsCompletionBlock)
    func fetchProductsOnline(url: NSURL, completion: ProductsCompletionBlock)
}

typealias ProductControllerStatusCompletionBlock = (() throws -> ProductControllerResult) -> Void

protocol ASCProductsFetchingControllerProtocol {
    var paginatedProducts: [ASCProduct] {get set}
    var onlyInStock: Bool! {get set}
    var searchText: String? {get set}
    var refresh: Bool {get set}
    var requestLimit: Int {get}
}
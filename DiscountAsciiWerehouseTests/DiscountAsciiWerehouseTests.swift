//
//  DiscountAsciiWerehouseTests.swift
//  DiscountAsciiWerehouseTests
//
//  Created by Matheus Ruschel on 8/1/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import XCTest
@testable import DiscountAsciiWerehouse

class DiscountAsciiWerehouseTests: XCTestCase {
    
    var expectation:XCTestExpectation!
    var delegateStatus = false
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewModel() {
        
        let viewModel = ASCProductsViewModel()
        viewModel.delegate = self
        
        var resultValidation = viewModel.validateSearchText("")
        XCTAssertTrue(resultValidation)
        resultValidation = viewModel.validateSearchText(nil)
        XCTAssertTrue(resultValidation)
        resultValidation = viewModel.validateSearchText("     ")
        XCTAssertFalse(resultValidation)
        
        expectation = self.expectationWithDescription("wait for delegate")

        viewModel.loadProducts(nil, onlyInStock: false, forceRefresh: false)
        
        waitForExpectationsWithTimeout(10, handler: { error in
            
            if error == nil {
                XCTAssertTrue(self.delegateStatus)
                XCTAssertFalse(viewModel.loadCellButtonIsEnabled)
                XCTAssertTrue(viewModel.showLoadingCellIsEnabled)
            } else {
                XCTFail()
            }
            
        })
        
    }
    
    func testFetchingController() {
        
        let fetchingController = ASCProductsFetchingController()
        
        fetchingController.fetchProducts(nil, onlyStock: false, forceRefresh: false, completion: {
            response in
            
            do {
                let status = try response()
                
                switch status {
                case .LoadedNewProducts(let products): XCTAssert(products.count == 10)
                case .NoResultsFound: XCTFail()
                case .ReachedLimit(_):XCTFail()
                    
                }
                
            }catch {
                XCTFail()
            }
            
        })
        
        
    }
    
    func testProductsAPI() {
        let productsAPI = ASCProductsAPI()
        
        productsAPI.fetchProducts(nil, onlyStock: false, skip: 0, limit: 10, completion: {
            response in
            
            do {
                try response()
                
                XCTAssertTrue(true)
            }catch {
                XCTFail()
            }
            
            
        })
        
        
        productsAPI.fetchProductsOnline(NSURL(string: ServerUrl)!, completion: {
            response in
        
            do {
                try response()
                XCTAssertTrue(true)
            }catch {
                XCTFail()
            }
        
        
        })
    }
    
    func testCommunicationModelResponse() {
        
        let commModel = ASCAPICommunicationModel()
        
        let url = NSURL(string: ServerUrl)
        commModel.fetchDataOnline(url!, completion: {
            response in
            
            do {
                try response()
                XCTAssertTrue(true)
            }catch {
                XCTFail()
            }
        
        })
    }
    
    func testCache() {
        
        let cache = CustomCache<NSData>()
        cache.clearCache()
        
        cache["birl"] = NSData()
        cache["lol"] = NSData()
        cache["largh"] = NSData()
        
        XCTAssert(cache.cacheSize() == 3)
        
        var cacheObj = cache["birl"]
        XCTAssertNil(cacheObj)
        cacheObj = cache["lol"]
        XCTAssertNil(cacheObj)
        cacheObj = cache["largh"]
        XCTAssertNil(cacheObj)
        
        NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector:#selector(clearCache), userInfo: nil, repeats: false)
        
        expectation = self.expectationWithDescription("wait for time to live to expire")
        
        waitForExpectationsWithTimeout(10, handler: { error in
        
            if error == nil {
                print("cache size = \(cache.cacheSize()!)")
                XCTAssert(cache.cacheSize() != 3)
            } else {
                XCTFail()
            }
        
        })
        
        
    }
    
    func clearCache() {
        CustomCache<NSData>.sharedInstance().clearCacheObjectsThatSurpassedTTL(2)
        expectation.fulfill()
    }
    
    func testUrlBuilder() {
        
        var partialURL = ASCUrlBuilder.getPartialUrlForParameter(.SearchTerm(searchText:"sdsdf"))
        XCTAssertNotNil(partialURL)
        partialURL = ASCUrlBuilder.getPartialUrlForParameter(.Limit(amount: 1))
        XCTAssertEqual(partialURL, "limit=1")
        partialURL = ASCUrlBuilder.getPartialUrlForParameter(.Limit(amount: -1))
        XCTAssertNil(partialURL)
        partialURL = ASCUrlBuilder.getPartialUrlForParameter(.OnlyInStock(bool:true))
        XCTAssertEqual(partialURL, "onlyInStock=1")
        partialURL = ASCUrlBuilder.getPartialUrlForParameter(.OnlyInStock(bool:false))
        XCTAssertEqual(partialURL, "onlyInStock=0")
        partialURL = ASCUrlBuilder.getPartialUrlForParameter(.Skip(amount: 10))
        XCTAssertEqual(partialURL, "skip=10")
        partialURL = ASCUrlBuilder.getPartialUrlForParameter(.Skip(amount: -10))
        XCTAssertNil(partialURL)
        
        var url = ASCUrlBuilder.buildUrl(forParameters: [])
        XCTAssertEqual(url!, NSURL(string:ServerUrl)!)
        url = ASCUrlBuilder.buildUrl(forParameters: [.SearchTerm(searchText:"blabla bli blu")])
        XCTAssertEqual(url!, NSURL(string:"\(ServerUrl)?q=blabla%20bli%20blu")!)
        
        
        url = ASCUrlBuilder.buildUrl(forParameters: [
                                                    .SearchTerm(searchText:"ipsum"),
                                                    .Limit(amount: -1),
                                                    .OnlyInStock(bool: true),
                                                    .Skip(amount: -10)])
        
        XCTAssertEqual(url!, NSURL(string:"\(ServerUrl)?q=ipsum&onlyInStock=1")!)
        
        url = ASCUrlBuilder.buildUrl(forParameters: [
            .SearchTerm(searchText:"ipsum and lol"),
            .Limit(amount: 1),
            .OnlyInStock(bool: true),
            .Skip(amount: 10)])
        
        XCTAssertEqual(url!, NSURL(string:"\(ServerUrl)?q=ipsum%20and%20lol&limit=1&onlyInStock=1&skip=10")!)
        
        url = ASCUrlBuilder.buildUrl(forParameters: [
            .SearchTerm(searchText:nil),
            .Limit(amount: -1),
            .Skip(amount: -10)])
        
        XCTAssertEqual(url!, NSURL(string:"\(ServerUrl)")!)


        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
extension DiscountAsciiWerehouseTests : ProductCoordinatorDelegate {
    
    func coordinatorDidFinishLoadingProducts(viewModel: ASCProductsViewModel, status: FetchStatus) {
        
        switch status {
        case .LoadedNewProducts: delegateStatus = true
        default: break
        }
        
        expectation.fulfill()
    }
    
    func coordinatorDidStartSearching(viewModel: ASCProductsViewModel) {
        
    }
}


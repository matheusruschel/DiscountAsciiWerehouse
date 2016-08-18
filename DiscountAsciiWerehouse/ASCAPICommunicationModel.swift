//
//  ASCAPICommunicationModel.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/1/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

typealias DataCallbackCompletionBlock =  (() throws -> AnyObject?) -> Void

class ASCAPICommunicationModel: NSObject {
    
    var session: NSURLSession!
    var cache: CustomCache<NSData>!
    
    override init() {
        super.init()
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.timeoutIntervalForRequest = 15
        session = NSURLSession(configuration: sessionConfig)
        cache = CustomCache<NSData>.sharedInstance()
        
    }
    
    func fetchData(url:NSURL, completion:DataCallbackCompletionBlock) {
        
            // cancels any request if there is on going requests before making a new one
            self.cancelDataRequests()
            // load from cache
            if let cacheObject = self.cache?[url.absoluteString] {
                let ndJsonParser = NDJSONParser(data:cacheObject.dataForCache())
                
                if ndJsonParser == nil {
                    completion({throw Error.ErrorWithCode(errorCode: .JSONNotRecognizedError)})
                } else {
                    completion({return ndJsonParser!.content })
                }
                
            } else {
                self.fetchDataOnline(url,completion:completion)
            }
        
    }
    
    func fetchDataOnline(url: NSURL, completion:DataCallbackCompletionBlock) {
        
        let task = session.dataTaskWithURL(url) {
            (data, response, error) in
            
            if error == nil {
                
                if let cache = self.cache {
                    
                    if data?.length != 0 {
                        cache[url.absoluteString] = data
                    }
                    
                }
                
                if let ndJsonParser = NDJSONParser(data:data!) {
                    completion({return ndJsonParser.content })
                } else {
                    completion({throw Error.ErrorWithCode(errorCode: .JSONNotRecognizedError)})
                }
                
                
            } else {
                let error = ErrorHandler.handleErrorFromServer(error!.code)
                
                switch error {
                case .ErrorWithCode(let errorCode): if errorCode != .CanceledTask { fallthrough }
                default: completion({ throw error})
                }
                
            }
            
        }
        task.resume()
    }
    
    func cancelDataRequests() {
        
        if let session = session {
            session.getTasksWithCompletionHandler() {
                (dataTasks,_,downloadTasks) in
                
                for task in dataTasks {
                    task.cancel()
                }
            }
        }
        
    }
    
    
}
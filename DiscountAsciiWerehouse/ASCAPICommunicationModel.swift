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
        session = NSURLSession.sharedSession()
        cache = CustomCache<NSData>.sharedInstance()
        
    }
    
    func fetchData(url:NSURL, completion:DataCallbackCompletionBlock) {
        
       
        // load from cache
        if let cacheObject = cache?[url.absoluteString] {
            let ndJsonParser = NDJSONParser(data:cacheObject.dataForCache())
            
            if ndJsonParser == nil {
                completion({throw Error.JSONNotRecognizedError})
            } else {
                completion({return ndJsonParser!.content })
            }
            
        } else {
             // cancels any request if there is on going requests before making a new one
            cancelDataRequests()
            fetchDataOnline(url,completion:completion)
        }
        
        
        
        
    }
    
    func fetchDataOnline(url: NSURL, completion:DataCallbackCompletionBlock) {
        
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            
            if error == nil {
                
                if let cache = self.cache {
                    cache[url.absoluteString] = data
                }
                
                let ndJsonParser = NDJSONParser(data:data!)
                
                if ndJsonParser == nil {
                    completion({throw Error.JSONNotRecognizedError})
                } else {
                    completion({return ndJsonParser!.content })
                }
                
                
            } else {
                completion({ throw Error.ErrorWithMsg(msg: error!.localizedDescription) })
            }
            
        }
        task.resume()
    }
    
    func cancelDataRequests() {
        
        if let session = session {
            session.getTasksWithCompletionHandler() {
                (dataTasks,_,_) in
                
                for task in dataTasks {
                    task.cancel()
                }
            }
        }
        
    }
    
    
}
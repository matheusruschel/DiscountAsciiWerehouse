//
//  ASCAPICommunicationModel.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/1/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

typealias DataCallbackCompletionBlock =  (() throws -> AnyObject?) -> Void

class ASCAPICommunicationModel {
    
    func fetchData(url:NSURL, completion:DataCallbackCompletionBlock) {
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data, response, error) in
            
            if error == nil {
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
    
    
}
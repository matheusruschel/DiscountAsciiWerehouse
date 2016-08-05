//
//  UrlBuilder.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/2/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

enum PARAM : String {
    case SearchTerm = "q", Skip = "skip", OnlyInStock = "onlyInStock", Limit = "limit"
}

class ASCUrlBuilder {
    
    let acceptedParamKeys = [PARAM.SearchTerm, .Skip, .OnlyInStock, .Limit]
    var params = [PARAM:AnyObject]()
    var finalUrl: String {

        var finalUrl = ServerUrl
        
        var accessoryForUrl = "?"
        for (key,value) in params {
            let partialUrl = getPartialUrlForParameter(key,value: value)
            finalUrl.appendContentsOf("\(accessoryForUrl)\(partialUrl)")
            accessoryForUrl = "&"
        }
        return finalUrl
    }
    
    private func getPartialUrlForParameter(paramType: PARAM, value:AnyObject) -> String {
        
        
        switch paramType {
        case .SearchTerm: guard ((value as? String) != nil) else {fatalError("Invalid type for parameter provided")}
        case .OnlyInStock: guard ((value as? Bool) != nil) else {fatalError("Invalid type for parameter provided")}
        case .Limit: fallthrough
        case .Skip: guard ((value as? Int) != nil) else {fatalError("Invalid type for parameter provided")}

        }
        
        return "\(paramType.rawValue)=\(value)"
        
    }
    
    init?(param: [PARAM:AnyObject]) {
        
        for key in param.keys {
            
            if !acceptedParamKeys.contains(key) {
                return nil
            }
        }
        self.params = param
        
    }

    
}
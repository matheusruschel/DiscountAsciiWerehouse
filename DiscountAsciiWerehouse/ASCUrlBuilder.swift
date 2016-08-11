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
    
    class func buildUrl(forParameters parameters:[PARAM:AnyObject]) -> NSURL? {
        
        var finalUrl = ServerUrl
        
        var accessoryForUrl = "?"
        for (key,value) in parameters {
            let partialUrl = ASCUrlBuilder.getPartialUrlForParameter(key,value: value)
            finalUrl.appendContentsOf("\(accessoryForUrl)\(partialUrl)")
            accessoryForUrl = "&"
        }
        
        return NSURL(string: finalUrl)
    }
    
    private class func getPartialUrlForParameter(paramType: PARAM, value:AnyObject) -> String {
        
        // checks for valid value for key
        switch paramType {
        case .SearchTerm: guard ((value as? String) != nil) else {fatalError("Invalid type for parameter provided")}
        case .OnlyInStock: guard ((value as? Bool) != nil) else {fatalError("Invalid type for parameter provided")}
        case .Limit: fallthrough
        case .Skip: guard ((value as? Int) != nil) else {fatalError("Invalid type for parameter provided")}

        }
        
        return "\(paramType.rawValue)=\(value)"
        
    }

    
}
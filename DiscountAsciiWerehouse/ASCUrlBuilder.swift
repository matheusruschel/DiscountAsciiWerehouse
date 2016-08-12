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
        case .SearchTerm:
            
        if let valueString = (value as? String) {
            return "\(paramType.rawValue)=\(valueString)"
        } else {
            fatalError("Invalid type for parameter provided")
        }
        case .OnlyInStock:
            
            if let valueInt = (value as? Int) {
                return "\(paramType.rawValue)=\(valueInt)"
            } else {
                fatalError("Invalid type for parameter provided")
            }
            
        case .Limit: fallthrough
        case .Skip:
            if let valueInt = value as? Int {
                return "\(paramType.rawValue)=\(valueInt)"
            } else {
                fatalError("Invalid type for parameter provided")
            }

        }
        
        
        
        
    }

    
}
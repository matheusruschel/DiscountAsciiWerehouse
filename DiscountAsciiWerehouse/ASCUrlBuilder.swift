//
//  UrlBuilder.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/2/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

enum PARAM {
    case SearchTerm(searchText:String?), Skip(amount:Int), OnlyInStock(bool:Bool), Limit(amount:Int)
}

class ASCUrlBuilder {
    
    class func buildUrl(forParameters parameters:[PARAM]) -> NSURL? {
        
        var finalUrl = ServerUrl
        
        var accessoryForUrl = "?"
        for value in parameters {
            
            if let partialUrl = ASCUrlBuilder.getPartialUrlForParameter(value) {
                finalUrl.appendContentsOf("\(accessoryForUrl)\(partialUrl)")
                accessoryForUrl = "&"
            }
            
        }
        
        return NSURL(string: finalUrl)
    }
    
    internal class func getPartialUrlForParameter(paramType: PARAM) -> String? {
        
        switch paramType {
        case .SearchTerm(let searchText):
            if let valueString = searchText {
                if let finalString = valueString.encodeString() {
                    return "\(SearchParam)=\(finalString)"
                }
            }
            return nil
        
        case .OnlyInStock(let bool):
            let valueInt = Int(bool)
            return "\(OnlyInStockParam)=\(valueInt)"

        case .Limit(let amount):
            if amount >= 0 {
                return "\(LimitParam)=\(amount)"
            }
            return nil
        case .Skip(let amount):
            if amount >= 0 {
                return "\(SkipParam)=\(amount)"
            }
            return nil
        }
        
        
        
        
    }

    
}
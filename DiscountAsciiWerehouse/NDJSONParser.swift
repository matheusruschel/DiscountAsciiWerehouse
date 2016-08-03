//
//  NDJSONParser.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/2/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

class NDJSONParser {
    
    var content: [AnyObject]?
    
    init?(data: NSData) {
        
        let ndJsonText = String(data: data, encoding: NSUTF8StringEncoding)
        content = ndJsonText!.componentsSeparatedByString("\n")
        content!.removeLast()
        content = content!.map({line in self.convertStringToDictionary(line as! String)!})
        
        if content == nil {
            return nil
        }
    }
    
    private func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch _ {
                return nil
            }
        }
        return nil
    }
    
}
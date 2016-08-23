//
//  String+Extension.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/11/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func encodeString() -> String? {
        
        if self.stringByReplacingOccurrencesOfString(" ", withString: "") != "" {
            let encodedSearchText = self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            return encodedSearchText
        }
        return nil
        
    }
}
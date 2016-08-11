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
    init(htmlEncodedString: String)  {
        do {
            let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedOptions : [String: AnyObject] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
            ]
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self.init(attributedString.string)
        } catch {
            fatalError("Failed to encode string: \(error)")
        }
    }
}
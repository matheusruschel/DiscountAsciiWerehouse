//
//  NSData+Extension.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/15/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import UIKit

extension NSData: CacheDescriptor {
    
    func dataForCache() -> NSData {
        return self
    }
    
}

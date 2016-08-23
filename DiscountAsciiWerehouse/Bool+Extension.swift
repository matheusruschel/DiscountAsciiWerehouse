//
//  Bool+Extension.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/22/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

extension Int {
    
    init(bool:Bool) {
        
        if bool {
            self.init(1)
        } else {
            self.init(0)
        }
    }

}
//
//  CacheDescriptor.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/18/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

protocol CacheDescriptor {
    init(data:NSData)
    func dataForCache() -> NSData
}
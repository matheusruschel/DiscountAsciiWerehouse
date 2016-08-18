//
//  CustomCacheProtocol.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/18/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation
import CoreData

protocol CustomCacheProtocol {
    
    associatedtype T
    var cacheObjects:[String: T] {get}
    subscript(key: String) -> T? {get set}
    static func sharedInstance() -> Self
    func addObject(object:T,forKey key: String)
    func clearCacheObjectsThatSurpassedTTL(allowedTTL:NSTimeInterval)
    func clearCache()
    func fetchObject(key: String) -> NSManagedObject?
    func loadObjectForKey(key: String)
    func fetchObjectsInCache() -> [NSManagedObject]?
    func loadCache()
}
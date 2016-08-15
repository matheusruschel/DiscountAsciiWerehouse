//
//  CustomCache.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/15/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import UIKit
import CoreData

protocol CacheDescriptor {
    init(data:NSData)
    func dataForCache() -> NSData
}

class CustomCache <T: CacheDescriptor> {

    private var cacheObjects = [String: T]()
    
    subscript(key: String) -> T? {
        get {
            return cacheObjects[key]
        }
        set(newValue) {
            addObject(newValue!, forKey: key)
        }
    }
    
    init() {
        loadCache()
    }
    
    class func sharedInstance() -> CustomCache<T> {
        return CustomCache<T>()
    }
    
    
     func addObject(object:T,forKey key: String) {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        

        let entity =  NSEntityDescription.entityForName("CacheObject",
                                                        inManagedObjectContext:managedContext)
        
        let cacheObject = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
        

        let date = NSDate()
        cacheObject.setValue(object.dataForCache(), forKey: "data")
        cacheObject.setValue(date, forKey: "timestamp")
        cacheObject.setValue(key, forKey: "keyValue")
        
        do {
            try managedContext.save()

            cacheObjects[key] = object
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func clearCache() {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "CacheObject")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.executeRequest(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print("Could not delete objects \(error), \(error.userInfo)")

        }
    }
    
    private func loadCache() {

        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: "CacheObject")
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            
            var loadedDic = [String: T]()
            for result in results as! [NSManagedObject] {
                let resultKey = result.valueForKey("keyValue") as! String
                let resultData = result.valueForKey("data") as! NSData
                loadedDic[resultKey] = T(data: resultData)
            }
            
            cacheObjects = loadedDic
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
}

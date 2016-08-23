//
//  CustomCache.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/15/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import UIKit
import CoreData

class CustomCache <T: CacheDescriptor> {
    
    subscript(key: String) -> T? {
        get {
            return loadObjectForKey(key)
        }
        set(newValue) {
            addObject(newValue!, forKey: key)
        }
    }
    
    let managedContext: NSManagedObjectContext!
    
    init() {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
    }
    
    class func sharedInstance() -> CustomCache<T> {
        return CustomCache<T>()
    }
    
    
     func addObject(object:T,forKey key: String) {

        let entity =  NSEntityDescription.entityForName("CacheObject",
                                                        inManagedObjectContext:managedContext)
        
        let cacheObject = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
        

        let date = NSDate()
        
        if object.dataForCache().length == 0 {
            cacheObject.setValue(nil, forKey: "data")
        } else {
            cacheObject.setValue(object.dataForCache(), forKey: "data")
        }
        cacheObject.setValue(date, forKey: "timestamp")
        cacheObject.setValue(key, forKey: "keyValue")
        
        do {
            try managedContext.save()

        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func clearCacheObjectsThatSurpassedTTL(allowedTTL:NSTimeInterval = 3600) {
            
            if let objects = self.fetchObjectsInCache() {
                
                for object in objects {
                    
                    let timestamp = object.valueForKey("timestamp") as! NSDate
                    let endDate = timestamp.dateByAddingTimeInterval(allowedTTL)
                    let currDate = NSDate()
                    
                    if currDate.compare(endDate) == .OrderedDescending {
                        managedContext.deleteObject(object)
                    }
                }
                
                do {
                    try managedContext.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
            }
            


    }

    
    func cacheSize() -> Int? {
        return self.fetchObjectsInCache()?.count
    }
    
    func clearCache() {
        
        let fetchRequest = NSFetchRequest(entityName: "CacheObject")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.executeRequest(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print("Could not delete objects \(error), \(error.userInfo)")

        }
    }
    
    private func fetchObject(key: String) -> NSManagedObject? {
        
        let fetchRequest = NSFetchRequest(entityName: "CacheObject")
        fetchRequest.predicate = NSPredicate(format: "keyValue == %@", key)
        fetchRequest.fetchLimit = 1
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            
            if results.count != 0 {
                return results[0] as? NSManagedObject
            } else {
                return nil
            }

            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return nil

        
    }
    
    private func loadObjectForKey(key: String) ->  T? {
        
        if let result = self.fetchObject(key) {
            if let resultData = result.valueForKey("data") as? NSData {
                return T(data: resultData)
            }
        }
        return nil

    }
    
    private func fetchObjectsInCache() -> [NSManagedObject]? {
            
            let fetchRequest = NSFetchRequest(entityName: "CacheObject")
            
            do {
                let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                
                return results as? [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }

        return nil
        
    }
    
}

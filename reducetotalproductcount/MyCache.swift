//
//  MyCache.swift
//  reducetotalproductcount
//
//  Created by 4A Labs on 15.09.2023.
//

import Foundation
class DoubleObject:NSObject {
    var value:Double?
    init(_ value: Double? = nil) {
        self.value = value
    }
}

class MyCache {
    private static let cache = NSCache<NSString, DoubleObject>()
    private static let lock = NSLock()
    private static var count = 0
    static func setValue(_ value: Double, forKey key: String) {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        cache.setObject(DoubleObject(value), forKey: NSString(string:key))
        count += 1
    }
    
    static func getValue(forKey key: String) -> DoubleObject? {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        return cache.object(forKey: key as NSString)
    }
    
    static func getcounts() -> Int {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        return count
    }
    
    static func removeValue(forKey key: String) {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        cache.removeObject(forKey: key as NSString)
    }
    
    static func removeAllValues() {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        cache.removeAllObjects()
    }
}

//
//  SimpleCache.swift
//  SimpleCache
//
//  Created by Nicolas Molina on 8/8/16.
//  Copyright © 2016 SimpleCache. All rights reserved.
//

import UIKit

public protocol SimpleCacheProtocol
{

    func dictionaryRepresentation() -> [String : AnyObject]
    func get(key: String, defaultValue: AnyObject?) -> AnyObject?
    func put(key: String, value: AnyObject?)
    func has(key: String) -> Bool
    func remove(key: String) -> AnyObject?

}

public class SimpleCache: NSObject
{

    private static let DEFAULT_CACHE_PREFIX = "user.cache."

    public static var DEFAULT_CACHE_SECONDS: Int = 60
    public static var CACHE_PROTOCOL: SimpleCacheProtocol = UserDefaultsCache.sharedInstance

    public class func get(key: String, defaultValue: AnyObject? = nil) -> AnyObject?
    {
        let cache = CACHE_PROTOCOL.dictionaryRepresentation()

        for cacheKey in cache.keys {
            if cacheKey.hasPrefix(DEFAULT_CACHE_PREFIX) && cacheKey.hasSuffix(key) {
                if !isExpirated(cacheKey) {
                    return CACHE_PROTOCOL.get(cacheKey, defaultValue: defaultValue)
                }
            }
        }
        return defaultValue
    }

    public class func put(key: String, value: AnyObject?, seconds: Int = DEFAULT_CACHE_SECONDS)
    {
        let date = NSDate().dateByAddingTimeInterval(Double(seconds))
        let timestamp = date.timeIntervalSince1970
        let cacheKey = getKey(Int(timestamp)) + key

        CACHE_PROTOCOL.put(cacheKey, value: value)
    }

    public class func has(key: String) -> Bool
    {
        return get(key) != nil
    }

    public class func remove(key: String) -> AnyObject?
    {
        let cache = CACHE_PROTOCOL.dictionaryRepresentation()

        for cacheKey in cache.keys {
            if cacheKey.hasPrefix(DEFAULT_CACHE_PREFIX) && cacheKey.hasSuffix(key) {
                return CACHE_PROTOCOL.remove(cacheKey)
            }
        }
        return nil
    }

    public class func clear()
    {
        let cache = CACHE_PROTOCOL.dictionaryRepresentation()

        for cacheKey in cache.keys {
            if cacheKey.hasPrefix(DEFAULT_CACHE_PREFIX) {
                CACHE_PROTOCOL.remove(cacheKey)
            }
        }
    }

    public class func cleanExpirated()
    {
        let cache = CACHE_PROTOCOL.dictionaryRepresentation()

        for cacheKey in cache.keys {
            if cacheKey.hasPrefix(DEFAULT_CACHE_PREFIX) && isExpirated(cacheKey) {
                CACHE_PROTOCOL.remove(cacheKey)
            }
        }
    }

    public class func isExpirated(key: String) -> Bool
    {
        if !key.hasPrefix(DEFAULT_CACHE_PREFIX) {
            return false
        }

        let now = Int(NSDate().timeIntervalSince1970)
        let partsCacheKey = key.characters.split{$0 == "."}.map(String.init)
        let timestamp = Int(partsCacheKey[2])!

        return timestamp < now
    }

    private class func getKey(timestamp: Int) -> String
    {
        return DEFAULT_CACHE_PREFIX + String(timestamp) + "."
    }

}

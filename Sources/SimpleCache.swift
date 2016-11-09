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

    func dictionaryRepresentation() -> [String : Any]
    func get(_ key: String, defaultValue: Any?) -> Any?
    func put(_ key: String, value: Any?)
    func has(_ key: String) -> Bool
    @discardableResult func remove(_ key: String) -> Any?

}

open class SimpleCache: NSObject
{

    fileprivate static let DEFAULT_CACHE_PREFIX = "user.cache."

    open static var DEFAULT_CACHE_SECONDS: Int = 60
    open static var CACHE_PROTOCOL: SimpleCacheProtocol = UserDefaultsCache.sharedInstance

    open class func get(_ key: String, defaultValue: Any? = nil) -> Any?
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

    open class func put(_ key: String, value: Any?, seconds: Int = DEFAULT_CACHE_SECONDS)
    {
        let date = Date().addingTimeInterval(Double(seconds))
        let timestamp = date.timeIntervalSince1970
        let cacheKey = getKey(Int(timestamp)) + key

        CACHE_PROTOCOL.put(cacheKey, value: value)
    }

    open class func has(_ key: String) -> Bool
    {
        return get(key) != nil
    }

    @discardableResult open class func remove(_ key: String) -> Any?
    {
        let cache = CACHE_PROTOCOL.dictionaryRepresentation()

        for cacheKey in cache.keys {
            if cacheKey.hasPrefix(DEFAULT_CACHE_PREFIX) && cacheKey.hasSuffix(key) {
                return CACHE_PROTOCOL.remove(cacheKey)
            }
        }
        return nil
    }

    open class func clear()
    {
        let cache = CACHE_PROTOCOL.dictionaryRepresentation()

        for cacheKey in cache.keys {
            if cacheKey.hasPrefix(DEFAULT_CACHE_PREFIX) {
                _ = CACHE_PROTOCOL.remove(cacheKey)
            }
        }
    }

    open class func cleanExpirated()
    {
        let cache = CACHE_PROTOCOL.dictionaryRepresentation()

        for cacheKey in cache.keys {
            if cacheKey.hasPrefix(DEFAULT_CACHE_PREFIX) && isExpirated(cacheKey) {
                _ = CACHE_PROTOCOL.remove(cacheKey)
            }
        }
    }

    open class func isExpirated(_ key: String) -> Bool
    {
        if !key.hasPrefix(DEFAULT_CACHE_PREFIX) {
            return false
        }

        let now = Int(Date().timeIntervalSince1970)
        let partsCacheKey = key.characters.split{$0 == "."}.map(String.init)
        let timestamp = Int(partsCacheKey[2])!

        return timestamp < now
    }

    fileprivate class func getKey(_ timestamp: Int) -> String
    {
        return DEFAULT_CACHE_PREFIX + String(timestamp) + "."
    }

}

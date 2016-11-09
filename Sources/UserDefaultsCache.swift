//
//  UserDefaultsCache.swift
//  SimpleCache
//
//  Created by Nicolas Molina on 8/8/16.
//  Copyright © 2016 SimpleCache. All rights reserved.
//

import UIKit

open class UserDefaultsCache: SimpleCacheProtocol
{

    static let sharedInstance = UserDefaultsCache()

    open func dictionaryRepresentation() -> [String : Any]
    {
        return UserDefaults.standard.dictionaryRepresentation() as [String : Any]
    }

    open func get(_ key: String, defaultValue: Any? = nil) -> Any?
    {
        let defaults = UserDefaults.standard
        let value = defaults.object(forKey: key)

        if value == nil {
            return defaultValue
        }
        return value as Any?
    }

    open func put(_ key: String, value: Any?)
    {
        if value == nil {
            remove(key)

        } else {
            let defaults = UserDefaults.standard

            defaults.set(value, forKey: key)
            defaults.synchronize()
        }
    }

    open func has(_ key: String) -> Bool
    {
        return get(key) != nil
    }

    @discardableResult open func remove(_ key: String) -> Any?
    {
        let defaults = UserDefaults.standard
        let value = get(key)

        defaults.removeObject(forKey: key)
        defaults.synchronize()

        return value
    }

}

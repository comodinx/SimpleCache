SimpleCache
=========
[![Version](http://img.shields.io/cocoapods/v/SimpleCache.svg?style=flat)](http://cocoapods.org/pods/SimpleCache) [![Platform](http://img.shields.io/cocoapods/p/SimpleCache.svg?style=flat)](http://cocoapods.org/pods/SimpleCache) [![License](http://img.shields.io/cocoapods/l/SimpleCache.svg?style=flat)](LICENSE)


Índice
------

* [Features][features].
* [Prerequisites][prerequisites].
* [Installation][Installation].
* [How to Use][how_to_use].
    + [Example][how_to_use_example].
    + [API][how_to_use_api].
        + [Default values][how_to_use_api_default_values].
        + [get][how_to_use_api_get].
        + [put][how_to_use_api_put].
        + [has][how_to_use_api_has].
        + [remove][how_to_use_api_remove].
        + [clear][how_to_use_api_clear].
        + [cleanExpirated][how_to_use_api_clean_expirated].
        + [isExpirated][how_to_use_api_is_expirated].
    + [Personalize][how_to_use_personalize].
* [License][license].


Features
--------
* Easy to use
* Personalize cache protocol
* Default cache protocol use user defaults


Prerequisites
-------------
* iOS 8+
* Xcode 7+
* Swift 2.0


Installation
------------
SimpleCache is available through CocoaPods. To install it, simply add the following line to your Podfile:
```
pod "SimpleCache"
```


How to Use
----------
Check out the demo project for a concrete example.

#### Example
``` swift
// String
SimpleCache.put("string", value: "This is a string")
print("Key: string\nValue: \(SimpleCache.get("string"))")

// Number
SimpleCache.put("number", value: 20.3)
print("Key: number\nValue: \(SimpleCache.get("number"))")

// JSON
SimpleCache.put("json", value: ["key": "value"])
print("Key: json\nValue: \(SimpleCache.get("json"))")

// NSData
SimpleCache.put("data", value: NSData(bytes: [0xFF, 0xD9] as [UInt8], length: 2))
print("Key: data\nValue: \(SimpleCache.get("data"))")

print("------------------------------")

// Remove an object from the cache
SimpleCache.remove("string")
print("Remove Key: string\nValue: \(SimpleCache.get("string"))")

print("------------------------------")

// Set expired key in 2 seconds
SimpleCache.put("string", value: "This is a string key expired in 2 seconds", seconds: 2)
print("Expired Key: string\nValue: \(SimpleCache.get("string"))")
print("Sleep 3 seconds")
dispatch_after(
    dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(3 * Double(NSEC_PER_SEC))
    ),
    dispatch_get_main_queue(),
    {
        self.print("Expired Key: string\nValue: \(SimpleCache.get("string"))")
    }
)

// Clean the cache
// SimpleCache.clear()

// Clean expired keys from cache
// SimpleCache.cleanExpirated()
```

#### API

##### Default values

Expired time in `seconds`. Default is `60`

```swift
SimpleCache.DEFAULT_CACHE_SECONDS: Int = 60 // Default is 1 minute

// Configure other time
SimpleCache.DEFAULT_CACHE_SECONDS = 5 * 60 // 5 minute
```

Expired time in `seconds`. Default is `60`

```swift
SimpleCache.CACHE_PROTOCOL: SimpleCacheProtocol = UserDefaultsCache.sharedInstance = 60 // Default cache use user defaults

// Configure other cache
SimpleCache.CACHE_PROTOCOL = MyCache()
```

##### get

```swift
SimpleCache.get(key: String, defaultValue: AnyObject? = nil)
```

Return value for `key` in cache. If not has `key` in cache return `defaultValue`.

```swift
SimpleCache.get("exist.key")                        // return value for "exist.key"
SimpleCache.get("not.exist.key")                    // return nil, because "not.exist.key" not exist in cache
SimpleCache.get("not.exist.key2", defaultValue: 10) // return 10, because "not.exist.key" not exist in cache, but defaultValue is set
```

##### put

```swift
SimpleCache.put(key: String, value: AnyObject?, seconds: Int = DEFAULT_CACHE_SECONDS)
```

Put `value` for `key` in cache. Expired in `seconds`.

```swift
SimpleCache.put("a.key", value: 10)                   // Expired in DEFAULT_CACHE_SECONDS
SimpleCache.put("a.key2", value: 10, seconds: 5 * 60) // Expired in 5 minutes
```

##### has

```swift
SimpleCache.has(key: String)
```

Return `true` if has value for `key` in cache, else `false`.

```swift
SimpleCache.has("exist.key")     // return true
SimpleCache.has("not.exist.key") // return false
```

##### remove

```swift
SimpleCache.remove(key: String)
```

Return value for `key` in cache if exist, and remove this key in cache.

```swift
SimpleCache.remove("exist.key")     // return value for "exist.key"
SimpleCache.remove("not.exist.key") // return nil, because "not.exist.key" not exist in cache
```

##### clear

Return remove all keys in cache.

```swift
SimpleCache.clear()
```

##### cleanExpirated

```swift
SimpleCache.cleanExpirated()
```

Return remove expirated keys in cache.

```swift
import SimpleCache

class AppDelegate: UIResponder, UIApplicationDelegate {

    // ...

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        // Clean cache expirated keys
        SimpleCache.cleanExpirated()

        return true
    }

    // ...

}
```

##### isExpirated

```swift
SimpleCache.isExpirated(key: String)
```

Return `true` if `key` in cache is expired, else `false`.

```swift
SimpleCache.put("a.key2", value: 10, seconds: 5 * 60) // Expired in 5 minutes

SimpleCache.isExpirated("a.key2") // return false

// Delay 6 minutes

SimpleCache.isExpirated("a.key2") // return true
```

#### Personalize

```swift
import SimpleCache

public class MyCache: SimpleCacheProtocol
{

    private var cache: [String : AnyObject] = [:]

    public func dictionaryRepresentation() -> [String : AnyObject] {
        return cache
    }

    public func get(key: String, defaultValue: AnyObject? = nil) -> AnyObject? {
        return cache[key]
    }

    public func put(key: String, value: AnyObject?) {
        cache[key] = value
    }

    public func has(key: String) -> Bool {
        return get(key) != nil
    }

    public func remove(key: String) -> AnyObject? {
        return cache.removeValueForKey(key)
    }
    
}

// Configure in AppDelegate.swift
class AppDelegate: UIResponder, UIApplicationDelegate {

    // ...

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        // Configure cache
        SimpleCache.CACHE_PROTOCOL = MyCache()

        return true
    }

    // ...

}
```


License
-------
SimpleCache is available under the MIT license. See the LICENSE file for more info.

<!-- deep links -->
[features]: #features
[screenshots]: #screen-shots
[prerequisites]: #prerequisites
[installation]: #installation
[how_to_use]: #how-to-use
[how_to_use_example]: #example
[how_to_use_api]: #api
[how_to_use_api_default_values]: #default-values
[how_to_use_api_get]: #get
[how_to_use_api_put]: #put
[how_to_use_api_has]: #has
[how_to_use_api_remove]: #remove
[how_to_use_api_clear]: #clear
[how_to_use_api_clean_expirated]: #cleanexpirated
[how_to_use_api_is_expirated]: #isexpirated
[how_to_use_personalize]: #personalize
[license]: #license

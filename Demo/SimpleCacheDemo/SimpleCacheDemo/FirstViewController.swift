//
//  FirstViewController.swift
//  SimpleCacheDemo
//
//  Created by Nicolas Molina on 9/30/16.
//  Copyright © 2016 Nicolas Molina. All rights reserved.
//

import UIKit
import SimpleCache
import SimpleLayout

class FirstViewController: BaseViewController
{

    override func setup()
    {
        super.setup()

        log("Default cache")
        log("------------------------------")

        // String
        SimpleCache.put("string", value: "This is a string")
        log("Key: string\nValue: \(SimpleCache.get("string"))")

        // Number
        SimpleCache.put("number", value: 20.3)
        log("Key: number\nValue: \(SimpleCache.get("number"))")

        // JSON
        SimpleCache.put("json", value: ["key": "value"])
        log("Key: json\nValue: \(SimpleCache.get("json"))")

        // NSData
        SimpleCache.put("data", value: Data(bytes: UnsafePointer<UInt8>([0xFF, 0xD9] as [UInt8]), count: 2))
        log("Key: data\nValue: \(SimpleCache.get("data"))")

        log("------------------------------")

        // Remove an object from the cache
        SimpleCache.remove("string")
        log("Remove Key: string\nValue: \(SimpleCache.get("string"))")

        log("------------------------------")

        // Set expired key in 2 seconds
        SimpleCache.put("string", value: "This is a string key expired in 2 seconds", seconds: 2)
        log("Expired Key: string\nValue: \(SimpleCache.get("string"))")
        log("Sleep 5 seconds")
        delay(5) {
            self.log("Expired Key: string\nValue: \(SimpleCache.get("string"))")
        }

        // Clean the cache
        // SimpleCache.clear()

        // Clean expired keys from cache
        // SimpleCache.cleanExpirated()
    }

}

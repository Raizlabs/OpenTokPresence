//
//  JSONHelpers.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/19/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

extension String {

    func toJSON<T>() -> T? {
        if
            let data = self.dataUsingEncoding(NSUTF8StringEncoding),
            let JSONObject = try? NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments]),
            let JSON = JSONObject as? T {
                return JSON
        }
        return nil
    }
    
}

protocol JSONType {}

extension Dictionary: JSONType {}
extension Array: JSONType {}
extension String: JSONType {}
extension Int: JSONType {}
extension Float: JSONType {}

extension JSONType {
    func toJSONString() -> String? {
        if let object = self as? AnyObject,
            let data = try? NSJSONSerialization.dataWithJSONObject(object, options:[]),
            let string = String(data:data, encoding: NSUTF8StringEncoding) {
                return string
        }
        return nil
    }
}


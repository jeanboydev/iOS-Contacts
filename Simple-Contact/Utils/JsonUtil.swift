//
//  JsonUtil.swift
//  Simple
//
//  Created by Next on 2017/11/7.
//  Copyright © 2017年 jeanboy. All rights reserved.
//

import Foundation
class JsonUtil {
    
    class func toJson<T:Codable>(_ obj:T) -> String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(obj)
        let str = String(data: data, encoding: String.Encoding.utf8)
        return str!
    }
    
    class func toObject<T:Codable>(_ type: T.Type, _ data:String) -> T {
        let decoder = JSONDecoder()
        let obj = try! decoder.decode(type, from: data.data(using: String.Encoding.utf8)!)
        return obj
    }
}

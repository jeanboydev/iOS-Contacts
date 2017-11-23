//
//  RepeatModel.swift
//  Simple-Contact
//
//  Created by jeanboy on 2017/11/22.
//  Copyright © 2017年 jeanboy. All rights reserved.
//

import Foundation
class RepeatModel: Codable {
    
    var identifier:String?//唯一标识
    var name:String?//姓名
    var number:[String]?//手机号
    
    init(identifier:String?, name:String?, number:[String]) {
        self.identifier = identifier
        self.name = name
        self.number = number
    }
}

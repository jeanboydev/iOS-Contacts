//
//  PhoneModel.swift
//  Simple-Contact
//
//  Created by jeanboy on 2017/11/21.
//  Copyright © 2017年 jeanboy. All rights reserved.
//

import Foundation
class MutableModel: Codable {
    
    var label:String?//前缀
    var value:String?//值
    
    init(label:String?, value:String) {
        self.label = label
        self.value = value
    }
}

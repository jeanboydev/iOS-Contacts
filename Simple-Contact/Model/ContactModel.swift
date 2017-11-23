//
//  ContactModel.swift
//  Simple-Contact
//
//  Created by jeanboy on 2017/11/21.
//  Copyright © 2017年 jeanboy. All rights reserved.
//

import Foundation
class ContactModel: Codable {
    
    var firstName:String?//名字
    var lastName:String?//姓
    var nickname:String?//昵称
    var note:String?//备注
    var emailArray:[MutableModel]?//邮箱
    var phoneArray:[MutableModel]?//电话
}

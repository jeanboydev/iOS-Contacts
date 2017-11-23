//
//  ContactUtil.swift
//  Simple-Contact
//
//  Created by jeanboy on 2017/11/21.
//  Copyright © 2017年 jeanboy. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI

class ContactUtil {
    
    //请求权限
    class func checkPermission(onSuccess:@escaping () -> (), onError:@escaping () -> ()){
        CNContactStore().requestAccess(for: CNEntityType.contacts) { (isRight, error) in
            if isRight {//授权成功
                onSuccess()
            } else {
                onError()
            }
        }
    }
    
    //Model 转 CNContact
    class func modelToContact(model:ContactModel) -> CNContact {
        let contact = CNMutableContact()
        //设置姓名
        contact.familyName = model.lastName ?? ""
        contact.givenName = model.firstName ?? ""
        //设置昵称
        contact.nickname = model.nickname ?? ""
        //设置备注
        contact.note = model.note ?? ""
        //设置手机号
        let phoneArray = model.phoneArray
        var phoneNumbers:Array<CNLabeledValue<CNPhoneNumber>> = Array<CNLabeledValue<CNPhoneNumber>>()
        if phoneArray != nil {
            for phoneModel in phoneArray! {
                let number = CNPhoneNumber(stringValue: phoneModel.value ?? "")
                let label = CNLabeledValue(label: phoneModel.label ?? CNLabelPhoneNumberMobile, value: number)
                phoneNumbers.append(label)
            }
        }
        contact.phoneNumbers = phoneNumbers
        //设置邮箱
        let emailArray = model.emailArray
        var emailAddress:Array<CNLabeledValue<NSString>> = Array<CNLabeledValue<NSString>>()
        if emailArray != nil {
            for emailModel in emailArray! {
                let label = CNLabeledValue(label: emailModel.label ?? CNLabelHome, value: (emailModel.value ?? "") as NSString)
                emailAddress.append(label)
            }
        }
        contact.emailAddresses = emailAddress
        return contact
    }
    
    //CNContact 转 Model
    class func contactToModel(contact:CNContact) -> ContactModel {
        
        let contactModel:ContactModel = ContactModel()
        
        //获取姓名
        let lastName = contact.familyName
        let firstName = contact.givenName
        debugPrint("姓名：\(lastName)\(firstName)")
        contactModel.lastName = lastName
        contactModel.firstName = firstName
        
        //获取昵称
        let nikeName = contact.nickname
        debugPrint("昵称：\(nikeName)")
        contactModel.nickname = nikeName
        
        //获取公司（组织）
        let organization = contact.organizationName
        debugPrint("公司（组织）：\(organization)")
        
        //获取职位
        let jobTitle = contact.jobTitle
        debugPrint("职位：\(jobTitle)")
        
        //获取部门
        let department = contact.departmentName
        debugPrint("部门：\(department)")
        
        //获取备注
        let note = contact.note
        debugPrint("备注：\(note)")
        contactModel.note = note
        
        var phoneArray:[MutableModel]? = contactModel.phoneArray
        if phoneArray == nil {
            phoneArray = [MutableModel]()
            contactModel.phoneArray = phoneArray
        }
        
        //获取电话号码
        debugPrint("电话：")
        for phone in contact.phoneNumbers {
            //获得标签名（转为能看得懂的本地标签名，比如work、home）
            var label:String?
            if phone.label != nil {
                label = CNLabeledValue<NSString>.localizedString(forLabel:
                    phone.label!)
            }
            
            //获取号码
            let value = phone.value.stringValue
            debugPrint("\(label ?? "")：\(value)")
            let mutableModel:MutableModel = MutableModel(label: label, value: value)
            phoneArray?.append(mutableModel)
        }
        contactModel.phoneArray = phoneArray
        
        var emailArray:[MutableModel]? = contactModel.emailArray
        if emailArray == nil {
            emailArray = [MutableModel]()
            contactModel.emailArray = emailArray
        }
        
        //获取Email
        debugPrint("Email：")
        for email in contact.emailAddresses {
            //获得标签名（转为能看得懂的本地标签名）
            var label:String?
            if email.label != nil {
                label = CNLabeledValue<NSString>.localizedString(forLabel:
                    email.label!)
            }
            
            //获取值
            let value = email.value as String
            debugPrint("\(label ?? "")：\(value)")
            let mutableModel:MutableModel = MutableModel(label: label, value: value)
            emailArray?.append(mutableModel)
        }
        contactModel.emailArray = emailArray
        
        //获取地址
        debugPrint("地址：")
        for address in contact.postalAddresses {
            //获得标签名（转为能看得懂的本地标签名）
            var label = "未知标签"
            if address.label != nil {
                label = CNLabeledValue<NSString>.localizedString(forLabel:
                    address.label!)
            }
            
            //获取值
            let detail = address.value
            let contry = detail.value(forKey: CNPostalAddressCountryKey) ?? ""
            let state = detail.value(forKey: CNPostalAddressStateKey) ?? ""
            let city = detail.value(forKey: CNPostalAddressCityKey) ?? ""
            let street = detail.value(forKey: CNPostalAddressStreetKey) ?? ""
            let code = detail.value(forKey: CNPostalAddressPostalCodeKey) ?? ""
            let str = "国家:\(contry) 省:\(state) 城市:\(city) 街道:\(street)"
                + " 邮编:\(code)"
            debugPrint("\t\(label)：\(str)")
        }
        
        //获取纪念日
        debugPrint("纪念日：")
        for date in contact.dates {
            //获得标签名（转为能看得懂的本地标签名）
            var label = "未知标签"
            if date.label != nil {
                label = CNLabeledValue<NSString>.localizedString(forLabel:
                    date.label!)
            }
            
            //获取值
            let dateComponents = date.value as DateComponents
            let value = NSCalendar.current.date(from: dateComponents)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
            debugPrint("\(label)：\(dateFormatter.string(from: value!))")
        }
        
        //获取即时通讯(IM)
        debugPrint("即时通讯(IM)：")
        for im in contact.instantMessageAddresses {
            //获得标签名（转为能看得懂的本地标签名）
            var label = "未知标签"
            if im.label != nil {
                label = CNLabeledValue<NSString>.localizedString(forLabel:
                    im.label!)
            }
            
            //获取值
            let detail = im.value
            let username = detail.value(forKey: CNInstantMessageAddressUsernameKey)
                ?? ""
            let service = detail.value(forKey: CNInstantMessageAddressServiceKey)
                ?? ""
            debugPrint("\(label)：\(username) 服务:\(service)")
        }
        
        return contactModel
    }
    
    //读取联系人
    class func loadContactDataToModel(onSuccess:@escaping (_ result:[ContactModel]) -> (), onError:@escaping (_ hasNoPermission:Bool) -> ()) {
        
        checkPermission(onSuccess: {
            //获取授权状态
            let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
            guard status == .authorized else {
                onError(true)
                return
            }
            
            var result:[ContactModel] = [ContactModel]()
            
            //创建通讯录对象
            let store = CNContactStore()
            //获取Fetch,并且指定要获取联系人中的什么属性
            let keys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactNicknameKey,
                        CNContactOrganizationNameKey, CNContactJobTitleKey,
                        CNContactDepartmentNameKey, CNContactNoteKey, CNContactPhoneNumbersKey,
                        CNContactEmailAddressesKey, CNContactPostalAddressesKey,
                        CNContactDatesKey, CNContactInstantMessageAddressesKey
            ]
            //创建请求对象
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            //遍历所有联系人
            do {
                try store.enumerateContacts(with: request, usingBlock: {
                    (contact : CNContact, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
                    
                    let contactModel = contactToModel(contact: contact)
                    result.append(contactModel)
                })
                
                DispatchQueue.main.async {
                    onSuccess(result)
                }
            } catch {
                debugPrint(error)
                DispatchQueue.main.async {
                    onError(false)
                }
            }
        }) {
            DispatchQueue.main.async {
                onError(false)
            }
        }
    }
    
    //添加联系人
    class func addContact(contactModel:ContactModel, onSuccess:@escaping () -> (), onError:@escaping (_ hasNoPermission:Bool) -> ()){
        checkPermission(onSuccess: {
            let store = CNContactStore()//创建通讯录对象
            let contactAdd = CNMutableContact()
            
            //赋值
            setValueFromModel(contact: contactAdd, model: contactModel)
            
            let saveRequest = CNSaveRequest()
            saveRequest.add(contactAdd, toContainerWithIdentifier: nil)
            
            do {
                try store.execute(saveRequest)
                debugPrint("=======保存成功=======")
                DispatchQueue.main.async {
                    onSuccess()
                }
            } catch {DispatchQueue.main.async {
                onError(false)
                }
            }
        }) {DispatchQueue.main.async {
            onError(true)
            }
        }
    }
    
    //赋值给 CNMutableContact
    private class func setValueFromModel(contact:CNMutableContact, model:ContactModel) {
        //设置姓名
        contact.familyName = model.lastName ?? ""
        contact.givenName = model.firstName ?? ""
        //设置昵称
        contact.nickname = model.nickname ?? ""
        //设置备注
        contact.note = model.note ?? ""
        //设置手机号
        let phoneArray = model.phoneArray
        var phoneNumbers:Array<CNLabeledValue<CNPhoneNumber>> = Array<CNLabeledValue<CNPhoneNumber>>()
        if phoneArray != nil {
            for phoneModel in phoneArray! {
                let number = CNPhoneNumber(stringValue: phoneModel.value ?? "")
                let label = CNLabeledValue(label: phoneModel.label ?? CNLabelPhoneNumberMobile, value: number)
                phoneNumbers.append(label)
            }
        }
        contact.phoneNumbers = phoneNumbers
        //设置邮箱
        let emailArray = model.emailArray
        var emailAddress:Array<CNLabeledValue<NSString>> = Array<CNLabeledValue<NSString>>()
        if emailArray != nil {
            for emailModel in emailArray! {
                let label = CNLabeledValue(label: emailModel.label ?? CNLabelHome, value: (emailModel.value ?? "") as NSString)
                emailAddress.append(label)
            }
        }
        contact.emailAddresses = emailAddress
    }
    
    //通过条件修改联系人
    private class func doActionContact(contactModel:ContactModel, onMatch:@escaping (_ contact:CNMutableContact, _ model:ContactModel) -> (Bool), isDelete:@escaping () -> (Bool),  onSuccess:@escaping () -> (), onError:@escaping (_ hasNoPermission:Bool) -> ()){
        
        checkPermission(onSuccess: {
            //创建通讯录对象
            let store = CNContactStore()
            
            //获取Fetch,并且指定要获取联系人中的什么属性
            let keys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactNicknameKey, CNContactNoteKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
            
            //创建请求对象，需要传入一个(keysToFetch: [CNKeyDescriptor]) 包含'CNKeyDescriptor'类型的数组
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            
            //遍历所有联系人
            do {
                try store.enumerateContacts(with: request, usingBlock: {
                    (contact : CNContact, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
                    
                    let mutableContact = contact.mutableCopy() as! CNMutableContact
                    
                    //判断是否符合要求
                    if onMatch(mutableContact, contactModel){
                        
                        if !isDelete() {
                            //更新数据
                            setValueFromModel(contact: mutableContact, model: contactModel)
                        }
                        
                        //修改联系人请求
                        let request = CNSaveRequest()
                        //处理操作
                        if isDelete() {
                            request.delete(mutableContact)
                        } else {
                            request.update(mutableContact)
                        }
                        
                        do {
                            //修改联系人
                            try store.execute(request)
                            debugPrint("=======操作成功=======")
                            DispatchQueue.main.async {
                                onSuccess()
                            }
                            return
                        } catch {
                            DispatchQueue.main.async {
                                onError(false)
                            }
                            return
                        }
                    }
                })
                DispatchQueue.main.async {
                    onSuccess()
                }
                debugPrint("=======操作成功===不需要修改====")
            } catch {
                DispatchQueue.main.async {
                    onError(false)
                }
            }
        }) {
            DispatchQueue.main.async {
                onError(true)
            }
        }
    }
    
    //姓名匹配
    private class func byName(contact:CNMutableContact, model:ContactModel) -> Bool{
        //获取姓名
        let lastName = contact.familyName
        let firstName = contact.givenName
        return lastName == model.lastName && firstName == model.firstName
    }
    
    //号码匹配
    private class func byPhoneNumber(phoneNumber:String, contact:CNMutableContact) -> Bool {
        for phone in contact.phoneNumbers {
            //获取号码
            let value = phone.value.stringValue
            if value == phoneNumber {
                return true
            }
        }
        return false
    }
    
    //通过姓名修改联系人
    class func updateContactByName (contactModel:ContactModel, onSuccess:@escaping () -> (), onError:@escaping (_ hasNoPermission:Bool) -> ()){
        
        doActionContact(contactModel: contactModel, onMatch: { (contact, model) -> (Bool) in
            return byName(contact: contact, model: model)
        }, isDelete: { () in
            return true
        }, onSuccess: onSuccess, onError: onError)
    }
    
    //通过手机号修改联系人
    class func updateContactByPhoneNumber (phoneNumber:String, contactModel:ContactModel, onSuccess:@escaping () -> (), onError:@escaping (_ hasNoPermission:Bool) -> ()){
        
        doActionContact(contactModel: contactModel, onMatch: { (contact, model) -> (Bool) in
            return byPhoneNumber(phoneNumber: phoneNumber, contact: contact)
        }, isDelete: { () in
            return true
        },onSuccess: onSuccess, onError: onError)
    }
    
    //通过姓名删除联系人
    class func deleteContactByName (firstName:String, lastName:String, onSuccess:@escaping () -> (), onError:@escaping (_ hasNoPermission:Bool) -> ()){
        
        let contactModel:ContactModel = ContactModel()
        contactModel.firstName = firstName
        contactModel.lastName = lastName
        
        doActionContact(contactModel: contactModel, onMatch: { (contact, model) -> (Bool) in
            return byName(contact: contact, model: model)
        }, isDelete: { () in
            return false
        }, onSuccess: onSuccess, onError: onError)
    }
    
    //通过手机号删除联系人
    class func deleteContactByPhoneNumber (phoneNumber:String, onSuccess:@escaping () -> (), onError:@escaping (_ hasNoPermission:Bool) -> ()){
        
        let contactModel:ContactModel = ContactModel()
        
        doActionContact(contactModel: contactModel, onMatch: { (contact, model) -> (Bool) in
            return byPhoneNumber(phoneNumber: phoneNumber, contact: contact)
        }, isDelete: { () in
            return false
        },onSuccess: onSuccess, onError: onError)
    }
    
    //读取并分析联系人
    class func loadContactWithAnalysis(onSuccess:@escaping (_ repeatNameArray:[String], _ repeatName:[String: [RepeatModel]], _ repeatNumberArray:[String], _ repeatNumber:[String: [RepeatModel]] ) -> (), onError:@escaping (_ hasNoPermission:Bool) -> ()) {
        
        //重复姓名
        //重复号码
        //[姓名,号码] [号码,姓名]
        //[姓名:[信息]] [号码:[信息]]
        var tempNameArray:[String] = [String]()//name
        var tempNumberArray:[String] = [String]()//number
        var tempNameDict:[String: RepeatModel] = [String: RepeatModel]()//name,identifier
        var tempNumberDict:[String: RepeatModel] = [String: RepeatModel]()//number,identifier
        
        var repeatNameArray:[String] = [String]()//name
        var repeatNumberArray:[String] = [String]()//number
        var repeatNameDict:[String: [RepeatModel]] = [String: [RepeatModel]]()//name,[identifier,...]
        var repeatNumberDict:[String: [RepeatModel]] = [String: [RepeatModel]]()//number,[identifier,...]
        
        func doAnalysis(isNumber:Bool, key:String, model:RepeatModel) -> (tempKeyArray:[String], tempDict:[String: RepeatModel], repeatKeyArray:[String], repeatDict:[String: [RepeatModel]]){
            
            var tempKeyArray = isNumber ? tempNumberArray : tempNameArray
            var tempDict = isNumber ? tempNumberDict : tempNameDict
            var repeatKeyArray = isNumber ? repeatNumberArray : repeatNameArray
            var repeatDict = isNumber ? repeatNumberDict : repeatNameDict
            
            if tempKeyArray.contains(key) {//出现重复
                let cacheModel = tempDict[key]!//取出与当前key重复的Model
                let cacheIdentifier = cacheModel.identifier
                
                var repeatModelArray:[RepeatModel]? = repeatDict[key]//取出相同key已经重复的model集合
                if repeatModelArray == nil {//第一次为空
                    repeatModelArray = [RepeatModel]()
                }
                
                var isHadCache:Bool = false//缓存model是否已经添加到重复集合中
                var isHadTemp:Bool = false//当前model是否已经添加到重复集合中
                
                for model in repeatModelArray! {
                    if model.identifier == cacheIdentifier {
                        isHadCache = true
                    }
                    
                    if model.identifier == model.identifier {
                        isHadTemp = true
                    }
                }
                
                if !isHadCache {//未添加则添加加到重复集合中
                    if !repeatKeyArray.contains(key){
                        repeatKeyArray.append(key)
                    }
                    repeatModelArray!.append(cacheModel)
                }
                
                if !isHadTemp {//未添加则将当前model添加到重复集合中
                     if !repeatKeyArray.contains(key){
                        repeatKeyArray.append(key)
                    }
                    repeatModelArray!.append(model)
                }
                repeatDict[key] = repeatModelArray
            } else {//没有重复将model添加到缓存
                tempKeyArray.append(key)
                tempDict[key] = model
            }
            return (tempKeyArray, tempDict, repeatKeyArray, repeatDict)
        }
        
        checkPermission(onSuccess: {
            //获取授权状态
            let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
            guard status == .authorized else {
                onError(true)
                return
            }
            
            //创建通讯录对象
            let store = CNContactStore()
            //获取Fetch,并且指定要获取联系人中的什么属性
            let keys = [CNContactIdentifierKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactNicknameKey, CNContactNoteKey, CNContactOrganizationNameKey, CNContactPhoneNumbersKey
            ]
            //创建请求对象
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            //遍历所有联系人
            do {
                try store.enumerateContacts(with: request, usingBlock: {
                    (contact : CNContact, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
                    
                    //获取唯一标识
                    let identifier = contact.identifier
                    //获取姓名
                    let lastName = contact.familyName
                    let firstName = contact.givenName
                    //获取昵称
                    let nikeName = contact.nickname
                    //获取备注
                    let note = contact.note
                    //获取公司（组织）
                    let organization = contact.organizationName
                    
                    let tempName = lastName+firstName+nikeName+note+organization
                    
                    var numberArray:[String]  = [String]()
                    
                    //获取电话号码
                    for phone in contact.phoneNumbers {
                        let number = phone.value.stringValue
                        numberArray.append(number)
                        
                        let result = doAnalysis(isNumber: true, key: number, model: RepeatModel(identifier: identifier, name: tempName, number: numberArray))
                        
                        tempNumberArray = result.tempKeyArray
                        tempNumberDict = result.tempDict
                        repeatNumberArray = result.repeatKeyArray
                        repeatNumberDict = result.repeatDict
                    }
                    
                    let result = doAnalysis(isNumber: false, key: tempName, model: RepeatModel(identifier: identifier, name: tempName, number: numberArray))
                    
                    tempNameArray = result.tempKeyArray
                    tempNameDict = result.tempDict
                    repeatNameArray = result.repeatKeyArray
                    repeatNameDict = result.repeatDict
                })
                
                DispatchQueue.main.async {
                    onSuccess(repeatNameArray, repeatNameDict, repeatNumberArray, repeatNumberDict)
                }
            } catch {
                debugPrint(error)
                DispatchQueue.main.async {
                    onError(false)
                }
            }
        }) {
            DispatchQueue.main.async {
                onError(false)
            }
        }
    }
    
    //通过identifier打开联系人详情
    class func toOpenContactDetail(identifier:String, controller:UINavigationController) {
        let store = CNContactStore()
        do {
            let result = try store.unifiedContact(withIdentifier: identifier, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
            DispatchQueue.main.async {
                let contactViewController = CNContactViewController(for: result)
                contactViewController.allowsEditing = true
                contactViewController.allowsActions = true
                controller.pushViewController(contactViewController, animated: true)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

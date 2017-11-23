//
//  ViewController.swift
//  Simple-Contact
//
//  Created by jeanboy on 2017/11/21.
//  Copyright © 2017年 jeanboy. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController, CNContactViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        ContactUtil.loadContactDataToModel(onSuccess: { (result) in
//            debugPrint(JsonUtil.toJson(result))
//
//            if result.count > 0 {
//                let model = result[result.count-1]
//                let contact = ContactUtil.modelToContact(model: model)
//                let contactViewController = CNContactViewController(for: contact)
//                contactViewController.navigationItem.title = "信息"
//                contactViewController.hidesBottomBarWhenPushed = true
//                contactViewController.allowsActions = false
//                contactViewController.allowsEditing = false
//                self.navigationController?.pushViewController(contactViewController, animated: true)
//            }
//        }) { (hasNoPermission) in
//            debugPrint("========no permission=====\(hasNoPermission)=")
//        }
        
//        let contactAdd = ContactModel()
//        contactAdd.firstName = "测试姓名"
//        contactAdd.lastName = "刘"
//
//        var phoneArray:[MutableModel] = [MutableModel]()
//        phoneArray.append(MutableModel(label: "", value: "13333333666"))
//        contactAdd.phoneArray = phoneArray

//        ContactUtil.addContact(contactModel: contactAdd, onSuccess: {
//            debugPrint("========添加成功=======")
//        }) { (hasNoPermission) in
//             debugPrint("========no permission=====\(hasNoPermission)=")
//        }
        
//        ContactUtil.updateContactByName(contactModel: contactAdd, onSuccess: {
//            debugPrint("========修改成功=======")
//        }) { (hasNoPermission) in
//            debugPrint("========no permission=====\(hasNoPermission)=")
//        }
        
//        ContactUtil.updateContactByPhoneNumber(phoneNumber: "13333333333", contactModel: contactAdd, onSuccess: {
//            debugPrint("========修改成功=======")
//        }) { (hasNoPermission) in
//            debugPrint("========no permission=====\(hasNoPermission)=")
//        }
        
//        ContactUtil.deleteContactByPhoneNumber(phoneNumber: "13333333666", onSuccess: {
//            debugPrint("========删除成功=======")
//        }) { (hasNoPermission) in
//            debugPrint("========no permission=====\(hasNoPermission)=")
//        }
        
//        ContactUtil.deleteContactByName(firstName: "David", lastName: "Taylor", onSuccess: {
//            debugPrint("========删除成功=======")
//        }) { (hasNoPermission) in
//           debugPrint("========no permission=====\(hasNoPermission)=")
//        }
        
//        ContactUtil.loadContactData(onSuccess: { (result) in
//            if result.count > 0 {
//                let contactViewController = CNContactViewController(for: result[result.count-1])
//                self.navigationController?.pushViewController(contactViewController, animated: true)
//            }
//        }) { (hasNoPermission) in
//            debugPrint("========no permission=====\(hasNoPermission)=")
//        }
//        displayContact()
        
        
//        let con = CNContact()
//        let vc = CNContactViewController(forNewContact: con)
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 40))
        button.setTitle("测试", for: UIControlState.normal)
        button.backgroundColor = UIColor.brown
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
       
        
    }
    
    @objc func buttonClick() {
        
        print("===========")
        let controller = TestViewController()
        
        let con = CNMutableContact()
        con.givenName = "Johnny"
        con.familyName = "Appleseed"
        con.phoneNumbers.append(CNLabeledValue(
            label: "woods", value: CNPhoneNumber(stringValue: "555-123-4567")))
        let unkvc = CNContactViewController(forUnknownContact: con)
        unkvc.message = "He knows his trees"
        unkvc.contactStore = CNContactStore()
        unkvc.delegate = self
        unkvc.allowsActions = false
//        self.present(unkvc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(unkvc, animated: true)
        
        displayContact()
        
//                ContactUtil.loadContactData(onSuccess: { (result) in
//                    if result.count > 0 {
//                        let contactViewController = CNContactViewController(for: result[result.count-1])
//                        self.navigationController?.pushViewController(contactViewController, animated: true)
//                    }
//                }) { (hasNoPermission) in
//                    debugPrint("========no permission=====\(hasNoPermission)=")
//                }
        
        //重复姓名
        //重复号码
        //[姓名,号码] [号码,姓名]
        //[姓名:[信息]] [号码:[信息]]
    }
    
    
    var store = CNContactStore()
    func fetchContact(with name: String, completion: @escaping (_ contacts: [CNContact]) -> Void) {
        var result = [CNContact]()
        
        do {
            result = try store.unifiedContacts(matching: CNContact.predicateForContacts(matchingName: name), keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
        } catch {
            
        }
        
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
    func displayContact() {
        let name = "测试姓名 王"
        
        fetchContact(with: name, completion: ({(contacts: [CNContact]) in
            DispatchQueue.main.async {
                if !contacts.isEmpty {
                    let contactViewController = CNContactViewController(for: contacts.first!)
                    contactViewController.allowsEditing = true
                    contactViewController.allowsActions = true
//                    contactViewController.delegate = self
                    
//                    if let highlightedPropertyIdentifiers = contacts.first?.phoneNumbers.first?.identifier {
//                        contactViewController.highlightProperty(withKey: self.phoneNumberKey, identifier: highlightedPropertyIdentifiers)
//                    }
                    
                    // Show the view controller.
                    self.navigationController?.pushViewController(contactViewController, animated: true)
                } else {
//                    self.alert(with: "\(AppConfiguration.Messages.couldNotFind) \(name) \(AppConfiguration.Messages.inContacts)")
//                    if let selectedIndexPath = self.tableRowSelected {
//                        self.tableView.deselectRow(at: selectedIndexPath, animated: false)
//                    }
                    print("============")
                }
            }
        }))
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


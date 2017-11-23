//
//  ContactTableViewController.swift
//  Simple-Contact
//
//  Created by jeanboy on 2017/11/22.
//  Copyright © 2017年 jeanboy. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {

    var repeatNameArray:[String] = [String]()//name
    var repeatNumberArray:[String] = [String]()//number
    var repeatNameDict:[String: [RepeatModel]] = [String: [RepeatModel]]()//name,[identifier,...]
    var repeatNumberDict:[String: [RepeatModel]] = [String: [RepeatModel]]()//number,[identifier,...]
    
    let cellIdentifier = "cellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        
        ContactUtil.loadContactWithAnalysis(onSuccess: { (repeatNameKeys, repeatName, repeatNumberKeys, repeatNumber) in
            debugPrint("====repeatNameKeys===\(JsonUtil.toJson(repeatNameKeys))")
            debugPrint("====repeatNumberKeys===\(JsonUtil.toJson(repeatNumberKeys))")
            debugPrint("====repeatName===\(JsonUtil.toJson(repeatName))")
            debugPrint("====repeatNumber===\(JsonUtil.toJson(repeatNumber))")
            self.repeatNameArray = repeatNameKeys
            self.repeatNumberArray = repeatNumberKeys
            self.repeatNameDict = repeatName
            self.repeatNumberDict = repeatNumber
            self.tableView.reloadData()
        }) { (hasNoPermission) in
            debugPrint("========no permission=====\(hasNoPermission)=")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return repeatNameDict.count + repeatNumberDict.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section < repeatNameDict.count {
            let key:String = repeatNameArray[section]
            let values:[RepeatModel] = repeatNameDict[key]!
            return values.count
        } else {
            let key:String = repeatNumberArray[section - repeatNameArray.count]
            let values:[RepeatModel] = repeatNumberDict[key]!
            return values.count
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        label.backgroundColor = UIColor.brown
        if section < repeatNameDict.count {
            let key:String = repeatNameArray[section]
            label.text = "重复姓名 \(key)"
        } else {
            let key:String = repeatNumberArray[section - repeatNameArray.count]
            label.text = "重复号码 \(key)"
        }
        return label
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        if indexPath.section < repeatNameDict.count {
            let key:String = repeatNameArray[indexPath.section]
            let values:[RepeatModel] = repeatNameDict[key]!
            cell.textLabel?.text = "\(values[indexPath.row].name!) : \(JsonUtil.toJson(values[indexPath.row].number))"
        } else {
            let key:String = repeatNumberArray[indexPath.section - repeatNameArray.count]
            let values:[RepeatModel] = repeatNumberDict[key]!
            cell.textLabel?.text = "\(values[indexPath.row].name!) : \(JsonUtil.toJson(values[indexPath.row].number))"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var identifier:String?
        if indexPath.section < repeatNameDict.count {
            let key:String = repeatNameArray[indexPath.section]
            let values:[RepeatModel] = repeatNameDict[key]!
            identifier = values[indexPath.row].identifier
        } else {
            let key:String = repeatNumberArray[indexPath.section - repeatNameArray.count]
            let values:[RepeatModel] = repeatNumberDict[key]!
            identifier = values[indexPath.row].identifier
        }
        ContactUtil.toOpenContactDetail(identifier: identifier!, controller: self.navigationController!)
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  TableViewController.swift
//  TestCloud
//
//  Created by Lê Hà Thành on 12/29/16.
//  Copyright © 2016 Lê Hà Thành. All rights reserved.
//

import UIKit
import CloudKit
class TableViewController: UITableViewController {
    var cellArray = [String]()
    var refresh: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(pullToRefresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresh)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewCell(_:)))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(downFile(_:)))
        var answer = 1
        let base = 3
        for index in 1...4 {
            print(index)
            answer = answer * base
        }
        
    }
    var i = 0
    func downFile(_ sender: AnyObject){
        cellArray = []
        let defaultContainer = CKContainer.default()
        let privateDB = defaultContainer.privateCloudDatabase
        
        let query = CKQuery(recordType: "Data", predicate: NSPredicate(value: true))
        privateDB.perform(query, inZoneWith: nil) { (results, error) in
            if error == nil {
                for result in results! {
                    if let nameGroup = result["ID"]{
                        self.cellArray.append(nameGroup as! String)
                        
                        let urlPath = Bundle.main.bundleURL.appendingPathComponent("Test\(nameGroup).realm")
                        print(urlPath)
                        let data = result["FileData"] as! Data
                        try! data.write(to: urlPath)
                    }
                }
                self.tableView.reloadData()
            } else {
                print(error.debugDescription)
            }
        }
        
    }
    
    func insertNewCell(_ sender: AnyObject){
        let defaultContainer = CKContainer.default()
        let privateDB = defaultContainer.privateCloudDatabase
        i += 1
        
        let urlPath = Bundle.main.path(forResource: "default", ofType: "realm")
        let url = URL(fileURLWithPath: urlPath!)
        let data = try! Data(contentsOf: url)
        let dataRecord = CKRecord(recordType: "Data")
        dataRecord.setValue(data, forKey: "FileData")
        dataRecord.setValue("\(i)", forKey: "ID")
        dataRecord.setValue("\(i)", forKey: "Name")
        privateDB.save(dataRecord) { (record, error) in
            if error != nil {
                print(error.debugDescription)
            }
            
        }
        
    }
    func pullToRefresh() {
        print("refresh")
        self.tableView.reloadData()
        self.refresh?.endRefreshing()
    }
    
    func a() {
        cellArray = []
        let defaultContainer = CKContainer.default()
        let privateDB = defaultContainer.privateCloudDatabase
        
        let query = CKQuery(recordType: "GroupTable", predicate: NSPredicate(value: true))
        privateDB.perform(query, inZoneWith: nil) { (results, error) in
            if error == nil {
                for result in results! {
                    if let nameGroup = result["NameGroup"]{
                        self.cellArray.append(nameGroup as! String)
                    }
                }
                self.tableView.reloadData()
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    
//    private func fetchUserRecordID() {
//        // Fetch Default Container
//        let defaultContainer = CKContainer.default()
//        
//        defaultContainer.fetchUserRecordID { (recordID, error) in
//            if let responseError = error {
//                print(responseError)
//            } else if let userRecordID = recordID {
//                
//                DispatchQueue.main.async {
//                    print(userRecordID)
//                    self.fetchUserRecord(userRecordID)
//                }
//            }
//            
//        }
//        
//    }
    
//    func fetchUserRecord(_ recordID: CKRecordID) {
//        // Fetch Default Container
//        let defaultContainer = CKContainer.default()
//        
//        // Fetch Private Database
//        let privateDatabase = defaultContainer.privateCloudDatabase
//        
//        // Fetch User Record
//        privateDatabase.fetch(withRecordID: recordID) { (record, error) -> Void in
//            if let responseError = error {
//                print(responseError)
//                
//            } else if let userRecord = record {
//                print(userRecord)
//            }
//        }
//    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = cellArray[indexPath.row]
        return cell
    }
    
}

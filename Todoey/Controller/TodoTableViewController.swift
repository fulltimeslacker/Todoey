//
//  ViewController.swift
//  Todoey
//
//  Created by Alan Wei Jung Lai on 2019-02-27.
//  Copyright © 2019 Alan Wei Jung Lai. All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController {
    var itemsArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
//        tableView.addGestureRecognizer(tapGesture)
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemsArray = items
//
//        } // Loads user save as Array variable using key TodoListArray
        
        let newItem = Item()
        newItem.title = "Find Goku"
        itemsArray.append(newItem)
        let newItem2 = Item()
        newItem2.title = "Get Sensu beans"
        itemsArray.append(newItem2)
        let newItem3 = Item()
        newItem3.title = "Kill Freezer"
        itemsArray.append(newItem3)
        
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemsArray = items
        }
    }

    let defaults = UserDefaults.standard // creates user defaults

    

    
    
    
    
    
    //Mark - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemsArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary Operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
       
        cell.accessoryType = item.done == true ? .checkmark : .none
        
//        if itemsArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//        print(itemsArray[indexPath.row])
        
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        
//        if itemsArray[indexPath.row].done == false {
//            itemsArray[indexPath.row].done = true
//        } else {
//            itemsArray[indexPath.row].done = false
//        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
//    @objc func tableViewTapped() {
//
//
//
//    }
    
    //Mark add new items
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        
        var addItemTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = addItemTextField.text!
            self.itemsArray.append(newItem)
            
        
            
            self.defaults.set(self.itemsArray, forKey: "TodoListArray") // saves current Array into user defaults as an array for key TodoListArray
            
            self.tableView.reloadData() // reloads table view after new item entered to dispaly
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new item"
            addItemTextField = alertTextfield
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}


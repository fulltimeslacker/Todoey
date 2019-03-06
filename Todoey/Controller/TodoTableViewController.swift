//
//  ViewController.swift
//  Todoey
//
//  Created by Alan Wei Jung Lai on 2019-02-27.
//  Copyright © 2019 Alan Wei Jung Lai. All rights reserved.
//

import UIKit
import RealmSwift

class TodoTableViewController: UITableViewController {
    var itemsArray: Results<Item>?
    let realm = try! Realm()
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //using singleton to set AppDelegate as an object, tapping into view context
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   
       
        // Do any additional setup after loading the view, typically from a nib.
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
//        tableView.addGestureRecognizer(tapGesture)
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemsArray = items
//
//        } // Loads user save as Array variable using key TodoListArray
//        
//        let newItem = Item()
//        newItem.title = "Find Goku"
//        itemsArray.append(newItem)
//        let newItem2 = Item()
//        newItem2.title = "Get Sensu beans"
//        itemsArray.append(newItem2)
//        let newItem3 = Item()
//        newItem3.title = "Kill Freezer"
//        itemsArray.append(newItem3)
        
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemsArray = items
//        }
        
          
    }

//let defaults = UserDefaults.standard // creates user defaults

    

    
    
    
    
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = itemsArray?[indexPath.row]
        {
        cell.textLabel?.text = item.title
        
        
        //Ternary Operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
       
        cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added yet"
        }
//        if itemsArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray?.count ?? 1
    }
    
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//        print(itemsArray[indexPath.row])
        
        
        if let items = itemsArray?[indexPath.row] {
            do {
                try realm.write {
                        items.done = !items.done
                    
                }
                
            } catch {
                print("There was an errror retrieving items \(error)")
            }
        }
        tableView.reloadData()
        
       // itemsArray?[indexPath.row].done = !(itemsArray?[indexPath.row].done)!
//
////        if itemsArray[indexPath.row].done == false {
////            itemsArray[indexPath.row].done = true
////        } else {
////            itemsArray[indexPath.row].done = false
////        }
//
//        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
//    @objc func tableViewTapped() {
//
//
//
//    }
    
    //MARK: - add new items
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        
        var addItemTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                        try self.realm.write {
                            let newItem = Item()
                            if addItemTextField.text != "" {
                                
                                newItem.title = addItemTextField.text!
                                newItem.dateCreated = Date()
                                currentCategory.items.append(newItem)
                                //newItem.parentCategory = self.selectedCategory
                                //self.itemsArray.append(newItem)
                            self.realm.add(newItem)
                            self.tableView.reloadData()
                            }
                        
                        }
                    
                } catch {
                print("Error creating category \(error)")
                
                }
            }
        }
        
            
           // self.defaults.set(self.itemsArray, forKey: "TodoListArray") // saves current Array into user defaults as an array for key TodoListArray
            
           
        
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new item"
            addItemTextField = alertTextfield
        }
        alert.addAction(cancelButton)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
    }
    
    
//    func saveItems (items: Item) {
//        do {
//            try realm.write {
//                realm.add(items)
//            }
//
//        } catch {
//            print("Error creating category \(error)")
//
//        }
////let encoder = PropertyListEncoder()
////
////        do {
////            // let data = try encoder.encode(itemsArray) removed since using context
////            // try data.write(to: dataFilePath!)
////
////            try context.save()
////
////        } catch {
////            print("Error encoding data \(error)")
////
////        }
//       self.tableView.reloadData() // reloads table view after new item entered to dispaly
////
//    }
    
    func loadItems() {
        
        itemsArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
}

//MARK: - search function
extension TodoTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemsArray = itemsArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//
//        loadItems(with: request, predicate: predicate)

        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }

    }
}


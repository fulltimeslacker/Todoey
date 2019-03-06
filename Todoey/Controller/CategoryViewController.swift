//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Alan Wei Jung Lai on 2019-03-04.
//  Copyright © 2019 Alan Wei Jung Lai. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: SwipeViewController {
    
    var categoryArray : Results<Category>?
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let realm = try! Realm()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        tableView.rowHeight = 80
        loadCategories()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Category added yet"
        
        //cell.textLabel?.textColor = UIColor.white
        //cell.backgroundColor = UIColor.black
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    //MARK: - Data manipulation Methods
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToDelete = self.categoryArray?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(categoryToDelete)
    
                }
            } catch {
                print("There was an error deleting \(error)")
            }
        }

    }
    
    func save (category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            print("Error creating category \(error)")
            
        }
        tableView.reloadData()
        
    }
    
    func loadCategories( ) {
//        do{
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error loading Categories \(error)")
//        }
        categoryArray = realm.objects(Category.self)

        tableView.reloadData()
    }
    //MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // If user selected a category, it will set the destinationVC variable in TODOLISTviewController as categoryArray @ indexpath.row
        let destinationVC = segue.destination as! TodoTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    
    //MARK: - add new categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var addItemTextField = UITextField()
        
        let alert = UIAlertController(title: "Add a New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            let newCategory = Category()
            if addItemTextField.text != "" {
            newCategory.name = addItemTextField.text!
            
            //self.categoryArray.append(newCategory)
            self.save(category: newCategory)
            }
            
            
            // self.defaults.set(self.itemsArray, forKey: "TodoListArray") // saves current Array into user defaults as an array for key TodoListArray
            
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new Category"
            addItemTextField = alertTextfield
        }
        alert.addAction(cancelButton)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    

}


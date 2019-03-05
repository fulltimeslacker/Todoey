//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Alan Wei Jung Lai on 2019-03-04.
//  Copyright © 2019 Alan Wei Jung Lai. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCells", for: indexPath)
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        //cell.textLabel?.textColor = UIColor.white
        //cell.backgroundColor = UIColor.black
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    //MARK: - Data manipulation Methods
    func saveCategories () {
        
        do {
            try context.save()
            
        } catch {
            print("Error creating category \(error)")
            
        }
        tableView.reloadData()
        
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest() ) {
        do{
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading Categories \(error)")
        }
        
        tableView.reloadData()
    }
    //MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(categoryArray[indexPath.row].name!)
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // If user selected a category, it will set the destinationVC variable in TODOLISTviewController as categoryArray @ indexpath.row
        let destinationVC = segue.destination as! TodoTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    
    //MARK: - add new categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var addItemTextField = UITextField()
        
        let alert = UIAlertController(title: "Add a New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            let newCategory = Category(context: self.context)
            if addItemTextField.text != "" {
            newCategory.name = addItemTextField.text!
            
            self.categoryArray.append(newCategory)
            self.saveCategories()
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

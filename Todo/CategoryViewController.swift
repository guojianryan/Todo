//
//  CategoryViewController.swift
//  Todo
//
//  Created by Ryan Guo on 17/7/2020.
//  Copyright © 2020 Ryan Guo. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    @IBOutlet weak var addButtonPressed: UIBarButtonItem!
    
    var categoryArray : [ToDoCategory] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
           
           // set the text from the data model
           
        cell.textLabel?.text = self.categoryArray[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! ViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selecteCategory = self.categoryArray[indexPath.row]
            }
            
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let category : ToDoCategory = ToDoCategory(context: self.context)
            category.name = textField.text!
            
            self.categoryArray.append(category)
            self.persistAndReload()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create Category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            self.context.delete(categoryArray[indexPath.row])
            categoryArray.remove(at: indexPath.row)
            self.persistAndReload()
        }
    }
    
   func persistAndReload() {
       do {
           try context.save()
       } catch {
           print("Error saving context, \(error)")
       }
       
       self.tableView.reloadData()
   }
   
       
    func loadData(with request: NSFetchRequest<ToDoCategory> = ToDoCategory.fetchRequest()) {
           do {
               self.categoryArray = try context.fetch(request)
           } catch {
               print("Error fetching data from context, \(error)")
           }
           tableView.reloadData()
    }
}

//
//  ViewController.swift
//  Todo
//
//  Created by Ryan Guo on 5/7/2020.
//  Copyright © 2020 Ryan Guo. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    var itemArray : [ToDoItem] = []
    
    var selecteCategory : ToDoCategory? {
        didSet{
            loadData()
        }
    }
        
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        // set the text from the data model
        
        cell.textLabel?.text = self.itemArray[indexPath.row].title
        
        if self.itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as UITableViewCell?
        
        self.itemArray[indexPath.row].done = !self.itemArray[indexPath.row].done
        
        if currentCell != nil {
            tableView.deselectRow(at: indexPath, animated: true)
            self.persistAndReload()
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let item : ToDoItem = ToDoItem(context: self.context)
            item.done = false
            item.title = textField.text!
            item.parentCategory = self.selecteCategory
            
            self.itemArray.append(item)
            
            self.persistAndReload()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func persistAndReload() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
        
    func loadData(with request: NSFetchRequest<ToDoItem>  = ToDoItem.fetchRequest(),predicate: NSPredicate? = nil) {
            do {
                let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", self.selecteCategory!.name!)
                if predicate != nil {
                    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
                    request.predicate = compoundPredicate
                }else {
                    request.predicate = categoryPredicate
                }
                self.itemArray = try context.fetch(request)
            } catch {
                print("Error fetching data from context, \(error)")
            }
            tableView.reloadData()
        }
}

//MARK: Search Bar
extension ViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request, predicate: NSPredicate(format : "title CONTAINS[cd] %@ ", searchBar.text!))
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadData()
            
            DispatchQueue.main.async{
                  searchBar.resignFirstResponder()
            }
        }
    }
    
    
}


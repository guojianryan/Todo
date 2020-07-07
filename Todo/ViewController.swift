//
//  ViewController.swift
//  Todo
//
//  Created by Ryan Guo on 5/7/2020.
//  Copyright © 2020 Ryan Guo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var itemArray : [ToDoItem] = []
    
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        
        let itemData = self.defaults.object(forKey: "ToDoListArray") as? NSData

        if itemData != nil {
            self.itemArray = NSKeyedUnarchiver.unarchiveObject(with: itemData! as Data) as? [ToDoItem] ?? []

        }
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
            let item : ToDoItem = ToDoItem(title: textField.text!, done: false)
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
        let itemData = NSKeyedArchiver.archivedData(withRootObject: self.itemArray)
        self.defaults.set(itemData,forKey: "ToDoListArray")
        self.tableView.reloadData()
    }
}


//
//  ViewController.swift
//  Todo
//
//  Created by Ryan Guo on 5/7/2020.
//  Copyright © 2020 Ryan Guo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var itemArray : [String] = []
    
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            self.itemArray = items
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        // set the text from the data model
        cell.textLabel?.text = self.itemArray[indexPath.row]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as UITableViewCell?

        if currentCell != nil {
            tableView.deselectRow(at: indexPath, animated: true)
            
            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            }else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
            
            print(currentCell!.textLabel!.text!)
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray,forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}


//
//  ViewController.swift
//  Todo
//
//  Created by Ryan Guo on 5/7/2020.
//  Copyright © 2020 Ryan Guo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    let itemArray = ["Find Mick", "Buy eggs", "Destroy Demogorgon"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
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
}


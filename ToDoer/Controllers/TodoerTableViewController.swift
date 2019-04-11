//
//  TodoerViewControllerTableViewController.swift
//  ToDoer
//
//  Created by Sarannya on 09/04/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import UIKit

class TodoerTableViewController: UITableViewController {

    var itemsArray = [Item]()
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var newItem = Item()
        newItem.title = "Send CVs"
        
        var newItem1 = Item()
        newItem1.title = "apply to companies"
        
        var newItem2 = Item()
        newItem2.title = "try hacker rank"
        
        itemsArray.append(newItem)
        itemsArray.append(newItem1)
        itemsArray.append(newItem2)
        
        if let items = userDefaults.array(forKey: "TodoListArray") as? [Item]
        {
            itemsArray = items
        }

    }

    
    // MARK: - Table view data source delegate methods


    //-----------------------------------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    //-----------------------------------------------------------------------------------------------------
    {
        // #warning Incomplete implementation, return the number of rows
        return itemsArray.count

    }

    
    //------------------------------------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    //------------------------------------------------------------------------------------------------------
    {

        let toDoItem = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath) as UITableViewCell
        toDoItem.textLabel?.text = itemsArray[indexPath.row].title
        
        toDoItem.accessoryType = itemsArray[indexPath.row].done ? .checkmark : .none
        
        return toDoItem
    }
    
    
    // MARK: - Table view delegate methods
    
    //-----------------------------------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    //-----------------------------------------------------------------------------------------------------
    {
        
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
       
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        print(itemsArray[indexPath.row])
    }

   // MARK: - Add New Items
    
    //-----------------------------------------------------------------------------------------------------
    @IBAction func addButtinPressed(_ sender: UIBarButtonItem)
    //-----------------------------------------------------------------------------------------------------
    {
        var itemTextField = UITextField()
        let alert = UIAlertController(title: "Add new todoer item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("success!")
            
            if itemTextField.text != "" {
                
                var newItem = Item()
                newItem.title = itemTextField.text!
                self.itemsArray.append(newItem)
                self.tableView.reloadData()
                self.userDefaults.set(self.itemsArray, forKey: "TodoListArray")
            }
        }
        alert.addTextField(configurationHandler: { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            itemTextField = alertTextField
        })
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
}

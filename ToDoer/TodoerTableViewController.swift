//
//  TodoerViewControllerTableViewController.swift
//  ToDoer
//
//  Created by Sarannya on 09/04/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import UIKit

class TodoerTableViewController: UITableViewController {

    var itemsArray = ["Buy Milk", "Apply to Bosch", "Clean Drawers"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        toDoItem.textLabel?.text = itemsArray[indexPath.row]
        
        return toDoItem
    }
    
    
    // MARK: - Table view delegate methods
    
    //-----------------------------------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    //-----------------------------------------------------------------------------------------------------
    {
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
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
                self.itemsArray.append(itemTextField.text!)
                self.tableView.reloadData()
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

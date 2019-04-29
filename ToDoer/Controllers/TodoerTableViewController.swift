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
//    let userDefaults = UserDefaults.standard
    var userDataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
//        print(userDataFilePath)
        
//        if let items = userDefaults.array(forKey: "TodoListArray") as? [Item]
//        {
//            itemsArray = items
//        }

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
        saveItems()
        
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
                
                self.saveItems()
                
//                self.userDefaults.set(self.itemsArray, forKey: "TodoListArray")
            }
        }
        alert.addTextField(configurationHandler: { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            itemTextField = alertTextField
        })
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    //-----------------------------------------------------------------------------------------------------
    func saveItems()
    //-----------------------------------------------------------------------------------------------------
    {
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(self.itemsArray)
            try data.write(to: self.userDataFilePath!)
        }catch{
            print("encoding error \(error)")
        }
        self.tableView.reloadData()
    }
    
    //-----------------------------------------------------------------------------------------------------
    func loadItems()
    //-----------------------------------------------------------------------------------------------------
    {
        if let data = try? Data(contentsOf: userDataFilePath!){
            let decoder = PropertyListDecoder()
            
            do{
                itemsArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding data \(data)")
            }
        }
    }
}

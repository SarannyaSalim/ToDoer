//
//  TodoerViewControllerTableViewController.swift
//  ToDoer
//
//  Created by Sarannya on 09/04/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import UIKit
import CoreData

class TodoerTableViewController: UITableViewController {

    var itemsArray = [Item]()
//    let userDefaults = UserDefaults.standard
    var userDataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")
    let appContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


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
        
//        appContext.delete(itemsArray[indexPath.row])
//        itemsArray.remove(at: indexPath.row)
        
//        itemsArray[indexPath.row].setValue(false, forKey: "done")
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
                
                let newItem = Item(context: self.appContext)
                newItem.title = itemTextField.text!
                newItem.done = false

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
        do{
        try appContext.save()
        }catch{
            print("Error saving data \(error)")
        }
        self.tableView.reloadData()
        
        /*
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(self.itemsArray)
            try data.write(to: self.userDataFilePath!)
        }catch{
            print("encoding error \(error)")
        }
        self.tableView.reloadData()
         */
    }
    
    //-----------------------------------------------------------------------------------------------------
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest())
    //-----------------------------------------------------------------------------------------------------
    {
        do{
           itemsArray = try appContext.fetch(request)
        }catch{
            print("Error fetching data \(error)")
        }
        
        tableView.reloadData()
        
        /*if let data = try? Data(contentsOf: userDataFilePath!){
            let decoder = PropertyListDecoder()
            
            do{
                itemsArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding data \(data)")
            }
        }*/
    }
}


extension TodoerTableViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
            
        }else{
            
            request.predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    
}

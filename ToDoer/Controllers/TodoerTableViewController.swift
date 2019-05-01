//
//  TodoerViewControllerTableViewController.swift
//  ToDoer
//
//  Created by Sarannya on 09/04/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import UIKit
import RealmSwift

class TodoerTableViewController: UITableViewController {

    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    // MARK: - Table view data source delegate methods


    //-----------------------------------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    //-----------------------------------------------------------------------------------------------------
    {
        // #warning Incomplete implementation, return the number of rows
        return todoItems?.count ?? 1

    }

    
    //------------------------------------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    //------------------------------------------------------------------------------------------------------
    {

        let toDoItemCell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            
            toDoItemCell.textLabel?.text = item.title
            
            toDoItemCell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            toDoItemCell.textLabel?.text = "No Item Added Yet"
        }
        
        
        return toDoItemCell
    }
    
    
    // MARK: - Table view delegate methods
    
    //-----------------------------------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    //-----------------------------------------------------------------------------------------------------
    {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("error changing done statuc \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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
                
                
                if let currentCategory = self.selectedCategory{
                    do{
                        try self.realm.write {
                            let item = Item()
                            item.title = itemTextField.text!
                            item.done = false
                            item.dateCreated = Date()
                            currentCategory.items.append(item)
                        }
                    }catch{
                        print("Error saving data \(error)")
                    }
                }
                
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
    
    //MARK: - Model Manipulation Methods
    
    
    //-----------------------------------------------------------------------------------------------------
    
    func loadItems()
    //-----------------------------------------------------------------------------------------------------
    {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
}


extension TodoerTableViewController : UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }

        }else{

            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()

        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
}


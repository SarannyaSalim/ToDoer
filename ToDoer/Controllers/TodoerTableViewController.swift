//
//  TodoerViewControllerTableViewController.swift
//  ToDoer
//
//  Created by Sarannya on 09/04/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoerTableViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        title = selectedCategory!.name
        guard let colorHex = selectedCategory?.cellColor else {
            fatalError()
        }
        
        setNavBarcColor(with: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        setNavBarcColor(with: "AAAAAA")
    }
    
    func setNavBarcColor(with hexcode : String){
        
        guard let navBar =  navigationController?.navigationBar else {
            fatalError("Navigation bar doesnot exists")
        }
        guard let navBarColor =  UIColor(hexString: hexcode) else {fatalError()}
        searchBar.barTintColor = navBarColor
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
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

        let toDoItemCell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            
            toDoItemCell.textLabel?.text = item.title
            
            toDoItemCell.accessoryType = item.done ? .checkmark : .none
            
            //setting gradient color depending on the parent category
            
            if let color = UIColor(hexString: selectedCategory!.cellColor){
                
                toDoItemCell.backgroundColor = color.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count))
                toDoItemCell.textLabel?.textColor = ContrastColorOf(toDoItemCell.backgroundColor!, returnFlat: true)
            }
            
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
    
    override func deleteRow(at indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch{
                print("error deleting todo iteme \(error)")
            }
        }
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


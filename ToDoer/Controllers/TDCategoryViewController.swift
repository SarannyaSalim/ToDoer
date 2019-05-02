//
//  TDCategoryViewController.swift
//  ToDoer
//
//  Created by Sarannya on 29/04/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TDCategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    
    var categoriesList : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist"))
        //TODO: call load method
        
        loadCategories()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categoriesList?.count ?? 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoriesList?[indexPath.row].name ?? "No category added yet"
       
        cell.backgroundColor = UIColor(hexString: (categoriesList?[indexPath.row].cellColor) ?? "AAAAAA")
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)


        return cell
    }
    
    // MARK: - Table view delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToItems"{
            
            let destinationVC = segue.destination as! TodoerTableViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoriesList?[(indexPath.row)]
            }
        }
    }
    
    
    //--------------------------------------------------------------------------------------
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    //--------------------------------------------------------------------------------------
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if textField.text != ""{
                let newCategory = Category()
                newCategory.name = textField.text!
//                self.categoriesList.append(newCategory)
                newCategory.cellColor = UIColor.randomFlat.hexValue()
                self.save(category: newCategory)
            }
        }
        
        alertController.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK : - Data Manipulation Methods
    
    func save(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("error saving categories: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        
        categoriesList = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func deleteRow(at indexPath: IndexPath) {
        if let categoryFordeletion = self.categoriesList?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryFordeletion)
                }
            }catch{
                print("error deleting category \(error)")
            }
        }
        
    }
}


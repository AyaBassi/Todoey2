//
//  CategoryViewController.swift
//  Todoey2
//
//  Created by Aya Bassi on 22/10/2018.
//  Copyright © 2018 Green Balloons. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController{

    let realm = try! Realm()
    var categoryArray: Results<Category>?
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        tableView.separatorStyle = .none
      
    }
    
// MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row]{
             cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString:category.randCelColHexCodeInStr) else {fatalError()}
            
                cell.backgroundColor = categoryColour
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
        }
       
        return cell
    }
    
    
//MARK: - Data Manipulation Methods

    
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving context\(error)")
        }
        tableView.reloadData()
    }
    
    
    
    func loadCategories(){
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    // MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("error deleting category \(error)")

            }
        }
    }
    
    
    
//MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Todoey new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style:.default) { (action) in
         print("success")
            if textField.text == "" {
                
                let emptyTextFieldAlert = UIAlertController(title: "Text field is empty!", message: "Please write an item in the text field!", preferredStyle: .alert)
                let emptyTextFieldAction = UIAlertAction(title: "OK", style: .default) { (emptyTextFieldAction) in
                    emptyTextFieldAlert.dismiss(animated: true, completion: nil)
                }
                emptyTextFieldAlert.addAction(emptyTextFieldAction)
                self.present(emptyTextFieldAlert, animated: true, completion: nil)
                
            } else {
                
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.randCelColHexCodeInStr = UIColor.randomFlat.hexValue()
               
                self.save(category: newCategory)
            }
        }
        alert.addTextField { (alertTexfield) in
        alertTexfield.placeholder = "Creat new Category"
            textField = alertTexfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil )
    }
    

    
   
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
         if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    
}


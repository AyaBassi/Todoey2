//
//  ViewController.swift
//  Todoey2
//
//  Created by Aya Bassi on 12/09/2018.
//  Copyright © 2018 Green Balloons. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

   // let defaults = UserDefaults.standard
   // var deleteTracking : Int = 0
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory,in:.userDomainMask))
     
        
    }
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    return itemArray.count
}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
      let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    

    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
       // itemArray[indexPath.row].setValue("Completed", forKey: "title")
//
//        if itemArray[indexPath.row].done == false && deleteTracking == 2  {
//            context.delete(itemArray[indexPath.row])
//            itemArray.remove(at: indexPath.row)
//            deleteTracking = 0
//            saveItems()
//    }
//        else {
//            itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//            deleteTracking = deleteTracking + 1
//            saveItems()
//        }
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        saveItems()
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //Completion block, What will happen once the user clicks the Add button on our Alert
           
            print("Success")
            if textField.text == "" {
                let emptyTextFieldAlert = UIAlertController(title: "Text field is empty!", message: "Please write an item in the text field!", preferredStyle: .alert)
                let emptyTextFieldAction = UIAlertAction(title: "OK", style: .default) { (emptyTextFieldAction) in
                    emptyTextFieldAlert.dismiss(animated: true, completion: nil)
                }
                emptyTextFieldAlert.addAction(emptyTextFieldAction)
               self.present(emptyTextFieldAlert, animated: true, completion: nil)
            } else {
                
                let newItem = Item(context: self.context)
                
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
                //self.defaults.set(self.itemArray, forKey: "TodoListArray")
               self.saveItems()
            }
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new Item"
           textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func saveItems(){
        do {
            try context.save()
        } catch {
           print("Erorr saving context\(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context\(error)")
        }
        tableView.reloadData()
    }
        
//       func loadItems(){
//            if let data = try? Data(contentsOf: dataFilePath!){
//                let decoder = PropertyListDecoder ()
//                do {
//                itemArray = try decoder.decode([Item].self, from: data)
//                } catch {
//                    print("Error decoding Item Array\(error)")
//                }
//            }
//        }
  
}

//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
       
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request,predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
        }
    }
}


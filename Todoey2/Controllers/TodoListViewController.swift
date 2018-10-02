//
//  ViewController.swift
//  Todoey2
//
//  Created by Aya Bassi on 12/09/2018.
//  Copyright © 2018 Green Balloons. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

   // let defaults = UserDefaults.standard
    
    var itemArray = [Item]()
    
      let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      
        
        print(dataFilePath)
     
        

        loadItems()
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
                
                let newItem = Item()
                
                newItem.title = textField.text!
                
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
        
        let encoder = PropertyListEncoder()
        do {
            
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error encoding itemArray\(error)")
        }
        
        self.tableView.reloadData()
    }
        
        func loadItems(){
            if let data = try? Data(contentsOf: dataFilePath!){
                let decoder = PropertyListDecoder ()
                do {
                itemArray = try decoder.decode([Item].self, from: data)
                } catch {
                    print("Error decoding Item Array\(error)")
                }
            }
        }
    
}


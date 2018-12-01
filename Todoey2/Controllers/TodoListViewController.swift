//
//  ViewController.swift
//  Todoey2
//
//  Created by Aya Bassi on 12/09/2018.
//  Copyright © 2018 Green Balloons. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    // let defaults = UserDefaults.standard
   // var deleteTracking : Int = 0
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
        
    var selectedCategory : Category? {
        didSet{
         loadItems()
        }
    }
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       // print(FileManager.default.urls(for: .documentDirectory,in:.userDomainMask))
     tableView.separatorStyle = .none
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colourHex = selectedCategory?.randCelColHexCodeInStr else {fatalError() }

        updateNavBar(withHexCode: colourHex)
        
    }
    
//   This will keep the navBar colour on category page, first page, the same through out.Because it takes the
//   colour of each Category after each category is selected.
//    override func viewWillDisappear(_ animated: Bool) {
//
//        updateNavBar(withHexCode: "1D9BF6")
//
//    }
    
    // MARK: - Nav Bar setup Methods
    func updateNavBar(withHexCode colourHexCode: String ) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError()}
        
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
    }
    
    
    
    
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    return todoItems?.count ?? 1
}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
      let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
        
            if let colour = UIColor(hexString:selectedCategory!.randCelColHexCodeInStr)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat( todoItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
 

    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            if let item = todoItems? [indexPath.row]{
                do {
                    try realm.write {
                      //  realm.delete(item)
                       item.done = !item.done
                    }
                    
                } catch {
                    print("Error saving done status,\(error)")
                }
        }
        
        tableView.reloadData()
        
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
                
                if let currentCategory = self.selectedCategory{
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new items,\(error)")
                    }
                  
                }
               self.tableView.reloadData()
            }
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new Item"
           textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    

    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    // MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("error deleting item \(error)")
                
            }
        }
    }
    
}

//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
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


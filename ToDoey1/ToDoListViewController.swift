//
//  ViewController.swift
//  ToDoey
//
//  Created by Craig Lester on 2/20/18.
//  Copyright © 2018 Craig Lester. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController  {
    
    
    //var toDoItemToAdd = UITextField()
    //let defaults = UserDefaults.standard
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //place to save data
    //let datafilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var itemArray = [Item]()
    var selectedCategory: Category?{
        didSet{
            
            loadItemsFromDisk()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        let newItem = Item()
//        newItem.title = "find Mike"
//        itemArray.append(newItem)
        
      
    
        
        //if we want to use user defaults
//        if let  items = defaults.array(forKey: "Item") as? [Item]{
//            itemArray = items
//        }
        
    }

   //Mark - Tableview Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let data = itemArray[indexPath.row]
        //if data.done == true set to checkmark else set to none
        cell.accessoryType = data.done  ? .checkmark : .none
        
//        if data.done == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        cell.textLabel?.text = data.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
             //to delete from database
       // context.delete(itemArray[indexPath.row])
       // itemArray.remove(at: indexPath.row)
        
         //toggle checkmark
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveDataToDisk()
        tableView.cellForRow(at: indexPath)?.accessoryView?.tintColor = UIColor.green
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
 
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert  = UIAlertController(title: "Add a New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //button clicked on alert
           
            let newItem = Item(context: self.context )
            newItem.title = textfield.text
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveDataToDisk()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = ("create new item")
            textfield = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveDataToDisk(){
        //self.defaults.set(self.itemArray, forKey: "Item")
        do{
            try context.save()
        }catch{
            print("error saving ToDoList \(error)")
        }
        tableView.reloadData()
    }
    
    
    //has a default value
    func loadItemsFromDisk(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        do{
            itemArray = try context.fetch(request)
        }catch{
            
        }
        tableView.reloadData()
    }
    
    
   
}
//MARK: - Search Bar
extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //%@ is a string
    
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItemsFromDisk(with: request, predicate: request.predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItemsFromDisk()
            DispatchQueue.main.async {//use main queue for views
                searchBar.resignFirstResponder() //clear keyboard and focus in searchbar
            }
        }        
    }
}















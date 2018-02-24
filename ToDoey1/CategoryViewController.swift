//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Craig Lester on 2/21/18.
//  Copyright © 2018 Craig Lester. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadItemsFromDisk()
 
    }

    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
            var textfield = UITextField()
            let alert  = UIAlertController(title: "Add a New Category", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                //button clicked on alert
                
                let newCategory = Category(context: self.context )
                newCategory.name = textfield.text!
                
                self.categoryArray.append(newCategory)
                self.saveDataToDisk()
            }
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = ("create new Category")
                textfield = alertTextField
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
    }
    
    
    func saveDataToDisk(){
        do{
            try context.save()
        }catch{
            print("error saving ToDoList \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadItemsFromDisk(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoryArray = try context.fetch(request)
       
            
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    
    //MARK: - tableview Datasource
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
//        cell.textLabel?.text = categoryArray[indexPath.row].name
//        //print(categoryArray[indexPath.row].name ?? "default")
//        return cell
//    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let data = categoryArray[indexPath.row]
  
        cell.textLabel?.text = data.name
        return cell
    }
    //MARK: - tableview delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            
            destination.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
  
}
